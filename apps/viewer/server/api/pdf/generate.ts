import puppeteer from "puppeteer"
import Handlebars from "handlebars"
import { H3Event } from "h3"
import { useDateFormat } from "@vueuse/core"
import type { Tables } from "~/types/database.types"

export default defineEventHandler(async (event: H3Event) => {
  const { pdfName, sport, year, date, schoolClass, registration_id, team_id } =
    await readBody(event)

  if (
    !sport ||
    !year ||
    !date ||
    !schoolClass ||
    !registration_id ||
    !team_id
  ) {
    throw createError({
      statusCode: 400,
      statusMessage: "Missing data fields",
    })
  }
  const timestamp = new Date().toISOString()
  const formattedDate = useDateFormat(date, "DD.MM.YYYY")
  const players = await $fetch<Tables<"player">[]>(
    `/api/players/query/find-by-team/${team_id}`,
  )
  const formattedPlayers = players?.map((player) => {
    return `${player.first_name} ${player.last_name}, ${player.class}`
  })

  const t = await useStorage("assets:templates").getItem(`pdf-template.html`)
  Handlebars.registerHelper("getPlayer", function (array, index) {
    return array[index] || ""
  })
  const template = Handlebars.compile(t)
  const html = template({
    date: formattedDate.value,
    players: formattedPlayers,
    id: registration_id,
    pdfName,
    sport,
    year,
    schoolClass,
    timestamp,
  })

  const browser = await puppeteer.launch({
    headless: true,
    args: ["--no-sandbox", "--disable-setuid-sandbox"],
  })

  try {
    const page = await browser.newPage()
    await page.setContent(html, {
      waitUntil: "networkidle2",
    })

    const pdfBuffer = await page.pdf({
      format: "A4",
      printBackground: true,
    })

    await browser.close()

    event.node.res.setHeader("Content-Type", "application/pdf")
    event.node.res.setHeader(
      "Content-Disposition",
      `inline; filename="${pdfName}"`,
    )
    return pdfBuffer
  } catch (error) {
    await browser.close()
    throw createError({
      statusCode: 500,
      statusMessage: "Error generating PDF",
    })
  }
})

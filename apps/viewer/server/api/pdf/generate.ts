import { existsSync } from "node:fs"
import puppeteer from "puppeteer"
import Handlebars from "handlebars"
import { H3Event } from "h3"
import { useDateFormat } from "@vueuse/core"
import type { Enums, Tables } from "@tourney/types"

const CHROMIUM_CANDIDATES = [
  "/usr/bin/chromium",
  "/usr/bin/chromium-browser",
  "/usr/bin/google-chrome-stable",
  "/usr/bin/google-chrome",
]

function resolveExecutablePath() {
  const configuredPath =
    process.env.PUPPETEER_EXECUTABLE_PATH ||
    process.env.CHROME_EXECUTABLE_PATH ||
    process.env.CHROMIUM_PATH

  if (configuredPath) {
    return configuredPath
  }

  const systemPath = CHROMIUM_CANDIDATES.find((path) => existsSync(path))
  if (systemPath) {
    return systemPath
  }

  try {
    return puppeteer.executablePath()
  } catch {
    return undefined
  }
}

export default defineEventHandler(async (event: H3Event) => {
  const {
    pdfName,
    sport,
    year,
    date,
    schoolClass,
    registration_id,
    team_id,
    deadline,
  } = await readBody(event)

  if (
    !sport ||
    !year ||
    !date ||
    !schoolClass ||
    !registration_id ||
    !team_id ||
    !deadline
  ) {
    throw createError({
      statusCode: 400,
      statusMessage: "Missing data fields",
    })
  }
  const timestamp = new Date().toISOString()
  const formattedDate = useDateFormat(date, "DD.MM.YYYY")
  const formattedDeadline = useDateFormat(deadline, "DD.MM.YYYY")
  const players = await $fetch<Tables<"player">[]>(
    `/api/players/query/find-by-team/${team_id}`,
  )
  const formattedPlayers = players?.map((player) => {
    return `${player.first_name} ${player.last_name}, ${player.class}`
  })

  const t =
    await useStorage("assets:templates").getItem<string>(`pdf-template.html`)
  if (!t) {
    throw createError({
      statusCode: 500,
      statusMessage: "PDF template not found",
    })
  }

  Handlebars.registerHelper("getPlayer", function (array, index) {
    return array[index] || ""
  })

  let money
  switch (sport as Enums<"sport_type">) {
    case "Fußball":
      money = 25
      break
    case "Basketball":
      money = 12
      break
    case "Volleyball":
      money = 15
      break
  }

  const template = Handlebars.compile(t)
  const html = template({
    date: formattedDate.value,
    deadline: formattedDeadline.value,
    players: formattedPlayers,
    id: registration_id,
    pdfName,
    sport,
    year,
    schoolClass,
    timestamp,
    money,
  })

  const launchOptions: Parameters<typeof puppeteer.launch>[0] = {
    headless: true,
    args: [
      "--no-sandbox",
      "--disable-setuid-sandbox",
      "--disable-dev-shm-usage",
      "--disable-gpu",
    ],
  }

  const executablePath = resolveExecutablePath()
  if (executablePath) {
    launchOptions.executablePath = executablePath
  }

  const browser = await puppeteer.launch(launchOptions)

  try {
    const page = await browser.newPage()
    await page.setContent(html, {
      waitUntil: "networkidle2",
    })

    const pdfBuffer = await page.pdf({
      format: "A4",
      printBackground: true,
    })

    event.node.res.setHeader("Content-Type", "application/pdf")
    event.node.res.setHeader(
      "Content-Disposition",
      `inline; filename="${pdfName}"`,
    )
    return pdfBuffer
  } catch (error) {
    console.error("Error generating PDF", {
      error,
      executablePath: executablePath || null,
    })

    throw createError({
      statusCode: 500,
      statusMessage: "Error generating PDF",
    })
  } finally {
    await browser.close()
  }
})

import puppeteer from "puppeteer"
import Handlebars from "handlebars"
import { H3Event } from "h3"

export default defineEventHandler(async (event: H3Event) => {
  const { name, orderNumber, total, pdfName } = await readBody(event)

  if (!name || !orderNumber || !total) {
    throw createError({
      statusCode: 400,
      statusMessage: "Missing data fields",
    })
  }

  const t = await useStorage("assets:templates").getItem(`pdf-template.html`)
  const template = Handlebars.compile(t)
  const html = template({ name, orderNumber, total })

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

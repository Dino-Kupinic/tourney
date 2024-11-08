import puppeteer from "puppeteer"
import { H3Event } from "h3"

export default defineEventHandler(async (event: H3Event) => {
  const { url } = await readBody(event)

  if (!url) {
    throw createError({
      statusCode: 400,
      statusMessage: "Missing URL parameter in body. What page to download?",
    })
  }

  const browser = await puppeteer.launch({
    headless: true,
    args: ["--no-sandbox", "--disable-setuid-sandbox"],
  })

  try {
    const page = await browser.newPage()
    await page.goto(url, {
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
      'inline; filename="generated.pdf"',
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

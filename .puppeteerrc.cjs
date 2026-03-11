const { join } = require("node:path")

/**
 * Keep the downloaded browser inside the app directory so it survives
 * build/runtime image boundaries in container deploys.
 *
 * @type {import("puppeteer").Configuration}
 */
module.exports = {
  cacheDirectory: join(__dirname, "node_modules", ".puppeteer_cache"),
}

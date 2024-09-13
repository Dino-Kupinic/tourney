import { fileURLToPath } from "url"
import { dirname, join } from "path"

// needed for layer relative import (https://nuxt.com/docs/guide/going-further/layers#relative-paths-and-aliases)
const currentDir = dirname(fileURLToPath(import.meta.url))

export default defineNuxtConfig({
  compatibilityDate: "2024-04-03",
  devtools: { enabled: true },
  modules: ["@nuxt/ui", "@nuxt/fonts", "@nuxt/test-utils"],
  css: [join(currentDir, "./assets/base.css")],
  fonts: {
    defaults: {
      weights: [400, 500],
      styles: ["normal", "italic"],
    },
    families: [{ name: "Inter", provider: "google" }],
  },
  colorMode: {
    preference: "light",
  },
  typescript: {
    typeCheck: true,
  },
})

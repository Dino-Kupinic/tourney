import { fileURLToPath } from "url"
import { dirname, join } from "path"
import pkg from "../../package.json"

// needed for layer relative import (https://nuxt.com/docs/guide/going-further/layers#relative-paths-and-aliases)
const currentDir = dirname(fileURLToPath(import.meta.url))

export default defineNuxtConfig({
  compatibilityDate: "2024-04-03",
  devtools: { enabled: true },
  modules: [
    "@nuxt/ui",
    "@nuxt/fonts",
    "@nuxt/test-utils",
    "@nuxt/image",
    "@nuxt/test-utils/module",
  ],
  css: [join(currentDir, "./assets/base.css")],
  runtimeConfig: {
    public: {
      clientVersion: pkg.version,
    },
  },
  fonts: {
    defaults: {
      weights: [400, 500, 600],
      styles: ["normal", "italic"],
    },
    families: [
      { name: "Inter", provider: "google" },
      { name: "JetBrains Mono", provider: "google" },
    ],
  },
  colorMode: {
    preference: "light",
  },
  typescript: {
    typeCheck: true,
  },
})

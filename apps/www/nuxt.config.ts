// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  modules: ["@nuxt/ui"],

  devtools: {
    enabled: true,
  },

  devServer: {
    port: 3002,
  },

  css: ["~/assets/css/main.css"],

  routeRules: {
    "/": { prerender: true },
  },

  compatibilityDate: "2025-07-28",
})

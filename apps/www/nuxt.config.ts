// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  extends: ["../../packages/core"],
  devtools: {
    enabled: true,
  },
  supabase: {
    redirect: false,
    types: "~~/types/database.types.ts",
  },
  devServer: {
    port: 3002,
  },
  routeRules: {
    "/": { prerender: true },
  },
  compatibilityDate: "2025-07-28",
})

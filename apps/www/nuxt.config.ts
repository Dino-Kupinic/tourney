// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  extends: ["../../packages/core"],
  devtools: {
    enabled: true,
  },
  runtimeConfig: {
    public: {
      adminAppUrl:
        process.env.NUXT_PUBLIC_ADMIN_APP_URL ??
        "https://tourney-admin.dino-kupinic.dev",
      viewerAppUrl:
        process.env.NUXT_PUBLIC_VIEWER_APP_URL ??
        "https://tourney-viewer.dino-kupinic.dev",
    },
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

// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  extends: ["../../packages/core"],
  compatibilityDate: "2024-04-03",
  devtools: { enabled: true },
  modules: ["@nuxtjs/supabase", "@vueuse/nuxt"],
  fonts: {
    defaults: {
      weights: [400, 500, 600],
      styles: ["normal"],
    },
    families: [{ name: "JetBrains Mono", provider: "google" }],
  },
  components: [
    {
      path: "~/components",
      pathPrefix: false,
    },
  ],
})

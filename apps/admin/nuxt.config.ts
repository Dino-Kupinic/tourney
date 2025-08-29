// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  extends: ["../../packages/core"],
  compatibilityDate: "2025-07-28",
  modules: ["@vueuse/nuxt", "@nuxtjs/supabase", "@nuxt/content"],
  devtools: { enabled: true },
  devServer: {
    port: 3000,
  },
  nitro: {
    preset: "bun",
  },
  components: [
    {
      path: "~/components",
      pathPrefix: false,
    },
  ],
  runtimeConfig: {
    public: {
      clientUrl: "",
    },
  },
  content: {
    markdown: {
      anchorLinks: false,
    },
  },
})

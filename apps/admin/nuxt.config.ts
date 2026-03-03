// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  extends: ["../../packages/core"],
  compatibilityDate: "2025-07-28",
  modules: ["@vueuse/nuxt"],
  devtools: { enabled: true },
  devServer: {
    port: 3000,
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
})

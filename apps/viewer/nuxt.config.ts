// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  extends: ["../../packages/core"],
  compatibilityDate: "2024-04-03",
  devtools: { enabled: true },
  modules: ["@nuxtjs/device", "@vueuse/nuxt", "@nuxtjs/supabase"],
  supabase: {
    redirect: false,
  },
  nitro: {
    serverAssets: [
      {
        baseName: "templates",
        dir: "./templates",
      },
    ],
  },
  devServer: {
    port: 3001,
  },
  components: [
    {
      path: "~/components",
      pathPrefix: false,
    },
  ],
})

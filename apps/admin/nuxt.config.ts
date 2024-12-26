// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  extends: ["../../packages/core"],
  compatibilityDate: "2024-04-03",
  modules: [
    "@vueuse/nuxt",
    "@nuxtjs/supabase",
    "nuxt-monaco-editor",
    "@nuxt/content",
  ],
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
  // mdc: {
  //   components: {
  //     prose: false, // Disable predefined prose components
  //     map: {
  //       p: "ProseH1",
  //     },
  //   },
  // },
  monacoEditor: {
    locale: "de",
  },
})
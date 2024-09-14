// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  extends: ["../../packages/core"],
  compatibilityDate: "2024-04-03",
  devtools: { enabled: true },
  modules: ["@nuxtjs/supabase"],
  fonts: {
    defaults: {
      weights: [400, 500, 600],
      styles: ["normal"],
    },
    families: [{ name: "JetBrains Mono", provider: "google" }],
  },
  supabase: {
    redirect: false, // TODO: remove after login page is implemented
  },
  components: [
    {
      path: "~/components",
      pathPrefix: false,
    },
  ],
});

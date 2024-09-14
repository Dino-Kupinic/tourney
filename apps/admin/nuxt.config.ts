// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  extends: ["../../packages/core"],
  compatibilityDate: "2024-04-03",
  devtools: { enabled: true },
  modules: ["@nuxtjs/supabase"],
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

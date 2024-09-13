// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2024-04-03',
  devtools: { enabled: true },
  modules: ['@nuxt/ui', '@nuxt/fonts'],
  css: ["~/assets/base.css"],
  fonts: {
    families: [
      { name: 'Inter', provider: 'google' },
    ]
  },
  colorMode: {
    preference: "light",
  },
  typescript: {
    typeCheck: true,
    strict: true,
  },
})

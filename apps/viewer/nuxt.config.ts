// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  extends: ["../../packages/core"],
  compatibilityDate: "2024-04-03",
  devtools: { enabled: true },
  modules: [
    "@nuxtjs/device",
    "@vueuse/nuxt",
    "@nuxtjs/supabase",
    "@vite-pwa/nuxt",
  ],
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
  pwa: {
    manifest: {
      name: "tourney",
      short_name: "tourney",
      theme_color: "#ffffff",
      icons: [
        {
          src: "pwa-64x64.png",
          sizes: "64x64",
          type: "image/png",
        },
        {
          src: "pwa-192x192.png",
          sizes: "192x192",
          type: "image/png",
        },
        {
          src: "pwa-512x512.png",
          sizes: "512x512",
          type: "image/png",
          purpose: "any",
        },
        {
          src: "maskable-icon-512x512.png",
          sizes: "512x512",
          type: "image/png",
          purpose: "maskable",
        },
        {
          src: "apple-touch-icon-180x180.png",
          sizes: "180x180",
          type: "image/png",
        },
      ],
    },
  },
})

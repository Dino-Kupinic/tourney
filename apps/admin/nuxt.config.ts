// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  extends: ["../../packages/core"],
  build: {
    transpile: ["monaco-editor"],
  },
  vite: {
    define: {
      global: "globalThis",
    },
    optimizeDeps: {
      include: ["monaco-editor/esm/vs/editor/editor.worker"],
    },
  },
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
  content: {
    markdown: {
      anchorLinks: false,
    },
  },
  monacoEditor: {
    locale: "de",
  },
})

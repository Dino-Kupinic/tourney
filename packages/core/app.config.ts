export default defineAppConfig({
  app: {
    head: {
      viewport: "width=device-width, initial-scale=1, maximum-scale=1",
    },
  },
  ui: {
    primary: "sky",
    gray: "neutral",
    card: {
      base: "text-sm",
      body: {
        padding: "py-2 sm:p-3",
      },
      header: {
        padding: "py-2 sm:px-3",
      },
      footer: {
        padding: "py-2 sm:px-3",
      },
    },
  },
})

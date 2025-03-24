import { DefaultTheme, defineConfig } from "vitepress"

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "tourney",
  sitemap: {
    hostname: "https://tourney.htl-steyr.ac.at/docs",
  },
  lang: "de-DE",
  description: "Offizielle tourney Dokumentation",
  head: [
    ["link", { rel: "icon", type: "image/png", href: "/favicon.png" }],
    ["link", { rel: "icon", type: "image/svg+xml", href: "/htl-steyr.svg" }],
    ["meta", { property: "og:type", content: "website" }],
    ["meta", { property: "og:locale", content: "de" }],
    [
      "meta",
      {
        property: "og:title",
        content: "tourney | Offizielle tourney Dokumentation",
      },
    ],
    ["meta", { property: "og:site_name", content: "tourney" }],
  ],
  themeConfig: {
    logo: {
      src: "/htl-logo.svg",
    },
    socialLinks: [
      {
        icon: "github",
        link: "https://github.com/Dino-Kupinic/tourney.git",
      },
    ],
    search: {
      provider: "local",
    },
    nav: nav(),
    sidebar: {
      "/users/": {
        base: "/users/",
        items: sidebarUsers(),
      },
      "/developers/": {
        base: "/developers/",
        items: sidebarDevelopers(),
      },
    },
    editLink: {
      pattern: "https://github.com/Dino-Kupinic/tourney/edit/main/docs/:path",
      text: "Seite auf GitHub bearbeiten",
    },
    lastUpdated: {
      text: "Aktualisiert am",
    },
    footer: {
      message: "Veröffentlicht unter der MIT Lizenz.",
      copyright: "Copyright © 2024-jetzt HTL Steyr",
    },
    docFooter: {
      prev: "Vorheriges",
      next: "Nächstes",
    },
  },
})

function nav(): DefaultTheme.NavItem[] {
  return [
    {
      text: "Home",
      link: "/",
    },
    {
      text: "Benutzer",
      link: "/users/getting-started",
    },
    {
      text: "Entwickler",
      link: "/developers/setup",
    },
  ]
}

function sidebarUsers(): DefaultTheme.SidebarItem[] {
  return [
    {
      text: "Einführung",
      collapsed: false,
      items: [
        {
          text: "Erste Schritte",
          link: "getting-started",
        },

        {
          text: "Hilfe",
          link: "help",
        },
      ],
    },
    {
      text: "Schüler App",
      collapsed: false,
      items: [
        {
          text: "Turniere anschauen",
          link: "tournaments",
        },
        {
          text: "Live mitverfolgen",
          link: "live",
        },
        {
          text: "Medien anschauen",
          link: "media",
        },
        {
          text: "Einstellungen",
          link: "settings",
        },
      ],
    },
    {
      text: "Admin Dashboard",
      collapsed: false,
      items: [
        {
          text: "Authentifizierung",
          link: "auth",
        },
        {
          text: "Turniere verwalten",
          link: "admin-tournaments",
        },
        {
          text: "Live Turniere führen",
          link: "admin-live",
        },
        {
          text: "Anmeldungen erstellen und verwalten",
          link: "admin-registration",
        },
        {
          text: "Bilder in der Galerie verwalten",
          link: "admin-gallery",
        },
        {
          text: "Aktuelle Informationen veröffentlichen",
          link: "admin-infos",
        },
        {
          text: "Klassenverwaltung",
          link: "admin-classes",
        },
      ],
    },
  ]
}

function sidebarDevelopers(): DefaultTheme.SidebarItem[] {
  return [
    {
      text: "Einführung",
      collapsed: false,
      items: [
        {
          text: "Einrichten",
          link: "setup",
        },
        {
          text: "Erweitern",
          link: "extending",
        },
        {
          text: "Deployment",
          link: "deployment",
        },
        {
          text: "Dokumentation ändern",
          link: "documentation",
        },
        {
          text: "Protokolle",
          link: "logging",
        },
      ],
    },
    {
      text: "Konventionen",
      collapsed: false,
      items: [
        {
          text: "Code Stil",
          link: "code-style",
        },
        {
          text: "Commits",
          link: "commits",
        },
        {
          text: "Git Flow",
          link: "git-flow",
        },
        {
          text: "Issues",
          link: "issues",
        },
        {
          text: "Pull Requests",
          link: "pull-requests",
        },
        {
          text: "Meilensteine",
          link: "milestones",
        },
        {
          text: "API",
          link: "api",
        },
      ],
    },
    {
      text: "Authentifizierung",
      collapsed: false,
      items: [
        {
          text: "LDAP",
          link: "ldap",
        },
        {
          text: "Sicherheit",
          link: "security",
        },
        {
          text: "An-/Abmeldung",
          link: "authentication",
        },
      ],
    },
    {
      text: "Internationalisierung",
      collapsed: false,
      items: [
        {
          text: "i18n",
          link: "internationalization",
        },
      ],
    },
    {
      text: "Datenpersistenz",
      collapsed: false,
      items: [
        {
          text: "Datenbank",
          link: "database",
        },
        {
          text: "XLSX Import",
          link: "import",
        },
        {
          text: "Services",
          link: "services",
        },
      ],
    },
  ]
}

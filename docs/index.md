---
layout: home

title: tourney
titleTemplate: Das nächste Level der Turnierverwaltung,

hero:
  name: "tourney"
  text: "Dokumentation"
  tagline: einfache und effiziente Turnierverwaltung
  actions:
    - theme: brand
      text: Quickstart für Benutzer
      link: /users/getting-started
    - theme: alt
      text: Entwickler Referenz
      link: /developers/setup
  image:
    src: /htl-logo.svg
    alt: HTL Steyr


features:
  - icon: 📑
    title: Anmeldungen verwalten
    details: Einfache Verwaltung von Anmeldungen
  - icon: 🏆
    title: Turnierverwaltung
    details: Turniere können mühelos erstellt, geplant und verwaltet werden
  - icon: 📊
    title: Live Ergebnisse
    details: Ergebnisse werden in Echtzeit aktualisiert und direkt angezeigt
  - icon: 🖼️
    title: Galerie und Medien
    details: Fotos können hochgeladen, verwaltet und präsentiert werden
  - icon: 🎨
    title: Konfigurierbar
    details: Konfigurieren die Anwendung nach deinen Wünschen
  - icon: 🔐
    title: Sicher
    details: Zugriffskontrolle und Datenschutz
  - icon: 🚀
    title: Performant
    details: Schnell, effizient und responsiv
---

<script setup>
import {
  VPTeamPage,
  VPTeamPageTitle,
  VPTeamMembers,
  VPTeamPageSection
} from "vitepress/theme"

const members = [
  {
    avatar: "https://github.com/Dino-Kupinic.png",
    name: "Dino Kupinic",
    title: "Software Entwickler und Projektleiter, 5AHITN 2024/25",
    links: [
      { icon: "github", link: "https://github.com/Dino-Kupinic" },
      { icon: "twitter", link: "https://x.com/DinoKupinic" }
    ]
  },
]

const partners = [
  {
    avatar: "https://api.dicebear.com/9.x/identicon/svg?seed=Jack",
    name: "Florian Hornbachner",
    title: "Project Owner",
    org: "HTL Steyr",
    orgLink: "https://www.htl-steyr.ac.at/",
  },
  {
    avatar: "https://github.com/prathgeb.png",
    name: "Peter Rathgeb",
    title: "Betreuer Softwarentwicklung",
    org: "HTL Steyr",
    orgLink: "https://www.htl-steyr.ac.at/",
    links: [
      { icon: "github", link: "https://github.com/prathgeb" },
    ]
  },
]

</script>

<VPTeamPage>
  <VPTeamPageTitle>
    <template #title>Team</template>
  </VPTeamPageTitle>
  <VPTeamMembers :members="members" />
</VPTeamPage>

<VPTeamPage>
  <VPTeamPageTitle>
    <template #title>Partner</template>
  </VPTeamPageTitle>
  <VPTeamMembers :members="partners" />
</VPTeamPage>

<style>
:root {
  --vp-home-hero-name-color: transparent;
  --vp-home-hero-name-background: -webkit-linear-gradient(120deg, #086dcb 30%, #1dbef3);

  --vp-home-hero-image-background-image: linear-gradient(-45deg, #242a3b 50%, #428faf 50%);
  --vp-home-hero-image-filter: blur(44px);
}

.dark {
  --vp-c-gutter: #28282d;
}

@media (min-width: 640px) {
  :root {
    --vp-home-hero-image-filter: blur(56px);
  }
}

@media (min-width: 960px) {
  :root {
    --vp-home-hero-image-filter: blur(68px);
  }
}
</style>


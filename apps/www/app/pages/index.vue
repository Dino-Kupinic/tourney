<script setup lang="ts">
import type { PageFeatureProps } from "@nuxt/ui"

type Locale = "en" | "de"
type CardId =
  | "tournaments"
  | "live"
  | "classes"
  | "news"
  | "registrations"
  | "gallery"
  | "results"
type FeatureId = "details" | "live" | "media"
type TextPair = { title: string; description: string }
type LandingCopy = {
  languageLabel: string
  hero: { title: string; subtitle: string; description: string }
  watch: string
  dashboard: string
  demoTitle: string
  cards: Record<CardId, TextPair>
  features: Record<FeatureId, TextPair>
  section: TextPair
  footballAlt: string
  imageCredit: string
  cta: TextPair
  legalNotice: string
  releases: string
  copyright: string
  seoTitle: string
  seoDescription: string
}

const COPY = {
  en: {
    languageLabel: "Language",
    hero: {
      title: "Host tournaments.",
      subtitle: "Without the chaos.",
      description:
        "The platform that manages complex brackets, creates custom schedules, and handles the organization while your team focuses on everything else.",
    },
    watch: "Watch",
    dashboard: "Dashboard",
    demoTitle: "Tourney product demo",
    cards: {
      tournaments: {
        title: "Tournaments",
        description:
          "Create football, volleyball, or basketball tournaments with rules, time slots, prizes, and automatic group assignments.",
      },
      live: {
        title: "Live control",
        description:
          "Start group stages, set matches live, and update results during the event.",
      },
      classes: {
        title: "Manage classes and year groups",
        description:
          "Manage classes by school year as the foundation for teams and registrations.",
      },
      news: {
        title: "Publish news",
        description: "Edit news directly in the dashboard.",
      },
      registrations: {
        title: "Manage registrations",
        description:
          "Create registration links, manage teams, and update registration statuses in one place.",
      },
      gallery: {
        title: "Manage the gallery",
        description: "Upload and manage photos in the media area.",
      },
      results: {
        title: "Tournament details and standings",
        description: "Every tournament has a public details page.",
      },
    },
    features: {
      details: {
        title: "Tournament details for everyone",
        description:
          "All tournaments are publicly available in the viewer with dates, locations, rules, and prizes.",
      },
      live: {
        title: "Live progress and standings",
        description:
          "The bracket, ongoing matches, and group standings update automatically.",
      },
      media: {
        title: "Media and updates",
        description:
          "Manage news and images in the admin dashboard and publish them directly to the viewer.",
      },
    },
    section: {
      title: "Everything for tournament day",
      description:
        "From registration to live results, the admin dashboard and viewer work together on one platform.",
    },
    footballAlt: "Football players at a tournament",
    imageCredit: "Image source:",
    cta: {
      title: "Ready to take your tournaments to the next level?",
      description:
        "Create your first tournament in seconds and let Tourney handle the organization so you can focus on what matters.",
    },
    legalNotice: "Legal notice",
    releases: "Releases",
    copyright: "Copyright",
    seoTitle: "Tourney - Tournament Management on Autopilot",
    seoDescription:
      "The platform that automatically manages brackets, crafts custom schedules, and runs events while your team does anything else.",
  },
  de: {
    languageLabel: "Sprache",
    hero: {
      title: "Turniere veranstalten.",
      subtitle: "Ohne das Chaos.",
      description:
        "Die Plattform, die komplexe Brackets verwaltet, maßgeschneiderte Spielpläne entwirft und die Organisation übernimmt, während sich dein Team auf alles andere konzentriert.",
    },
    watch: "Zuschauen",
    dashboard: "Dashboard",
    demoTitle: "Tourney Produktdemo",
    cards: {
      tournaments: {
        title: "Turniere",
        description:
          "Erstelle Fußball-, Volleyball- oder Basketballturniere mit Regeln, Zeitfenstern, Preisen und automatischer Gruppeneinteilung.",
      },
      live: {
        title: "Live-Steuerung",
        description:
          "Starte Gruppenphasen, setze Matches live und aktualisiere Ergebnisse direkt während des Events.",
      },
      classes: {
        title: "Klassen und Jahrgänge pflegen",
        description:
          "Verwalte Klassen pro Schuljahr als Grundlage für Team- und Anmeldelogik.",
      },
      news: {
        title: "Aktuelles veröffentlichen",
        description: "Bearbeite Neuigkeiten direkt im Dashboard",
      },
      registrations: {
        title: "Anmeldungen verwalten",
        description:
          "Erstelle Registrierungslinks, verwalte Teams und bearbeite den Status von Anmeldungen zentral.",
      },
      gallery: {
        title: "Galerie verwalten",
        description: "Lade Fotos hoch und verwalte diese im Medienbereich.",
      },
      results: {
        title: "Turnierdetails und Platzierungen",
        description: "Jedes Turnier hat eine öffentliche Detailseite",
      },
    },
    features: {
      details: {
        title: "Turnierdetails für alle",
        description:
          "Alle Turniere mit Datum, Ort, Regeln und Preisen sind im Viewer öffentlich verfügbar.",
      },
      live: {
        title: "Live-Flow und Tabellen",
        description:
          "Der Turnierbaum, laufende Matches und Gruppenstände werden automatisch aktualisiert.",
      },
      media: {
        title: "Medien und Updates",
        description:
          "News und Bilder lassen sich im Admin pflegen und direkt im Viewer veröffentlichen.",
      },
    },
    section: {
      title: "Alles für den Turniertag",
      description:
        "Vom Anmeldeprozess bis zur Live-Auswertung arbeiten Admin und Viewer in einer gemeinsamen Plattform zusammen.",
    },
    footballAlt: "Fußballspieler bei einem Turnier",
    imageCredit: "Bildquelle:",
    cta: {
      title: "Bereit, deine Turniere auf das nächste Level zu bringen?",
      description:
        "Erstelle dein erstes Turnier in Sekunden und erlebe, wie Tourney die Organisation übernimmt, damit du dich auf das Wesentliche konzentrieren kannst",
    },
    legalNotice: "Impressum",
    releases: "Releases",
    copyright: "Copyright",
    seoTitle: "Tourney - Turnierorganisation auf Autopilot",
    seoDescription:
      "Die Plattform, die Turnierbäume automatisch verwaltet, individuelle Spielpläne erstellt und Veranstaltungen organisiert, während sich dein Team um alles andere kümmert.",
  },
} satisfies Record<Locale, LandingCopy>

definePageMeta({ colorMode: "light" })

const {
  public: { adminAppUrl, viewerAppUrl, muxDemoPlaybackId },
} = useRuntimeConfig()
const demoVideoPlaybackId = computed(() => muxDemoPlaybackId.trim())
const locale = useState<Locale>("landing-locale", () => "en")
const copy = computed(() => COPY[locale.value])
const storageKey = "tourney:landing:locale"

function setLocale(next: Locale) {
  locale.value = next
  try {
    localStorage.setItem(storageKey, next)
  } catch {
    // The selected language still applies when storage is unavailable.
  }
}

onMounted(() => {
  try {
    const saved = localStorage.getItem(storageKey)
    if (saved === "en" || saved === "de") locale.value = saved
  } catch {
    // Keep the default language when storage is unavailable.
  }
})

useSeoMeta({
  title: () => copy.value.seoTitle,
  description: () => copy.value.seoDescription,
  ogTitle: () => copy.value.seoTitle,
  ogDescription: () => copy.value.seoDescription,
  twitterCard: "summary_large_image",
})

useHead({
  htmlAttrs: { lang: locale },
  script: [
    { src: "https://cdn.jsdelivr.net/npm/@mux/mux-player", defer: true },
  ],
})

const items = computed(() => [
  {
    label: "GitHub",
    to: "https://github.com/HTL-Steyr/tourney",
    target: "_blank",
  },
  {
    label: copy.value.legalNotice,
    to: "https://dino-kupinic.dev/impressum",
    target: "_blank",
  },
  {
    label: copy.value.releases,
    to: "https://github.com/HTL-Steyr/tourney/releases",
    target: "_blank",
  },
])

const cardPresentation = [
  {
    id: "tournaments",
    icon: "i-lucide-trophy",
    target: "_blank",
    class: "lg:col-span-2",
    orientation: "horizontal" as const,
  },
  {
    id: "live",
    icon: "i-lucide-signal",
    target: "_blank",
    variant: "soft" as const,
  },
  {
    id: "classes",
    icon: "i-lucide-graduation-cap",
    target: "_blank",
    variant: "soft" as const,
  },
  {
    id: "news",
    icon: "i-lucide-newspaper",
    target: "_blank",
    variant: "soft" as const,
  },
  {
    id: "registrations",
    icon: "i-lucide-ticket",
    target: "_blank",
    class: "lg:row-span-2",
  },
  { id: "gallery", icon: "i-lucide-images", target: "_blank" },
  {
    id: "results",
    icon: "i-lucide-list-ordered",
    target: "_blank",
    variant: "soft" as const,
  },
] satisfies Array<{
  id: CardId
  icon: string
  target: string
  class?: string
  orientation?: "horizontal"
  variant?: "soft"
}>
const cards = computed(() =>
  cardPresentation.map(({ id, ...presentation }) => ({
    id,
    ...presentation,
    ...copy.value.cards[id],
  })),
)

const featurePresentation = [
  {
    id: "details",
    icon: "i-lucide-calendar-days",
    to: `${viewerAppUrl}/tournaments`,
  },
  { id: "live", icon: "i-lucide-git-branch-plus", to: `${viewerAppUrl}/live` },
  { id: "media", icon: "i-lucide-images", to: `${viewerAppUrl}/media` },
] satisfies Array<{ id: FeatureId; icon: string; to: string }>
const features = computed<PageFeatureProps[]>(() =>
  featurePresentation.map(({ id, ...presentation }) => ({
    ...presentation,
    ...copy.value.features[id],
  })),
)
</script>

<template>
  <UPage>
    <main class="relative overflow-hidden pt-32 pb-24 md:pt-40">
      <div class="mx-auto max-w-7xl px-6 lg:px-8">
        <div
          class="mb-8 flex gap-2"
          role="group"
          :aria-label="copy.languageLabel"
        >
          <button
            v-for="language in [
              { code: 'en', label: 'English' },
              { code: 'de', label: 'Deutsch' },
            ] as const"
            :key="language.code"
            type="button"
            :lang="language.code"
            :aria-pressed="locale === language.code"
            class="rounded-full border px-3 py-1 text-sm font-medium focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-blue-600"
            :class="
              locale === language.code
                ? 'border-blue-600 bg-blue-600 text-white'
                : 'border-neutral-300 text-neutral-700'
            "
            @click="setLocale(language.code)"
          >
            {{ language.label }}
          </button>
        </div>
        <div class="max-w-3xl">
          <h1
            class="mb-6 text-3xl leading-tight font-bold tracking-tighter text-neutral-900 sm:font-semibold md:text-7xl"
          >
            {{ copy.hero.title }} <br />
            {{ copy.hero.subtitle }}
          </h1>
          <p
            class="mb-6 max-w-2xl text-lg leading-tight text-neutral-500 sm:mb-10 md:text-xl"
          >
            {{ copy.hero.description }}
          </p>
          <div
            class="flex flex-row items-start gap-2 sm:flex-row sm:items-center sm:gap-4"
          >
            <NuxtLink
              :to="viewerAppUrl"
              external
              class="inline-flex items-center justify-center rounded-full bg-blue-600 px-6 py-3 text-base font-medium text-white shadow-sm transition-all hover:bg-blue-700 focus:ring-2 focus:ring-blue-600 focus:ring-offset-2 focus:outline-none active:scale-95"
            >
              {{ copy.watch }}
            </NuxtLink>
            <NuxtLink
              :to="adminAppUrl"
              external
              class="inline-flex items-center justify-center rounded-full border border-neutral-200 bg-white px-6 py-3 text-base font-medium text-neutral-700 transition-all hover:border-neutral-300 hover:bg-neutral-50"
            >
              {{ copy.dashboard }}
            </NuxtLink>
          </div>
        </div>

        <div id="video-demo" class="relative mt-20">
          <div
            class="overflow-hidden rounded-3xl border border-neutral-800 bg-neutral-950 shadow-2xl"
          >
            <div
              class="pointer-events-none hidden h-12 items-center gap-2 border-b border-white/10 bg-neutral-950/90 px-6 sm:flex"
            >
              <div class="flex gap-2">
                <div class="h-3 w-3 rounded-full bg-red-500/80"></div>
                <div class="h-3 w-3 rounded-full bg-yellow-500/80"></div>
                <div class="h-3 w-3 rounded-full bg-green-500/80"></div>
              </div>
            </div>

            <div class="aspect-video w-full">
              <ClientOnly v-if="demoVideoPlaybackId">
                <mux-player
                  :playback-id="demoVideoPlaybackId"
                  stream-type="on-demand"
                  :metadata-video-title="copy.demoTitle"
                  :title="copy.demoTitle"
                  thumbnail-time="5"
                  class="h-full w-full"
                />
              </ClientOnly>
            </div>
          </div>
        </div>

        <div id="features" class="mt-32 border-t border-neutral-100 pt-16">
          <UPageGrid>
            <UPageCard v-for="card in cards" :key="card.id" v-bind="card">
            </UPageCard>
          </UPageGrid>
        </div>

        <div class="mt-32">
          <UPageSection
            :title="copy.section.title"
            :description="copy.section.description"
            icon="i-lucide-layout-dashboard"
            orientation="horizontal"
            :features="features"
          >
            <div class="w-full">
              <NuxtImg
                src="/football.jpg"
                width="600"
                height="700"
                :alt="copy.footballAlt"
                class="w-full rounded-lg"
                loading="lazy"
              />
              <p class="mt-2 text-right text-xs text-neutral-500">
                {{ copy.imageCredit }}
                <NuxtLink
                  to="https://www.freepik.com"
                  external
                  target="_blank"
                  class="underline underline-offset-2"
                >
                  freepik.com
                </NuxtLink>
              </p>
            </div>
          </UPageSection>
        </div>

        <div
          class="relative my-32 overflow-hidden rounded-[3rem] bg-neutral-900 px-6 py-20 text-center text-white lg:py-24"
        >
          <div
            class="absolute inset-0 bg-[radial-gradient(ellipse_at_top,rgba(37,99,235,0.3),transparent_50%)]"
          ></div>

          <div class="relative z-10 mx-auto max-w-3xl">
            <h2
              class="mb-6 text-4xl font-semibold tracking-tighter md:text-6xl"
            >
              {{ copy.cta.title }}
            </h2>
            <p class="mx-auto mb-10 max-w-xl text-lg text-neutral-400">
              {{ copy.cta.description }}
            </p>
            <div
              class="flex flex-col items-center justify-center gap-4 sm:flex-row"
            >
              <NuxtLink
                :to="adminAppUrl"
                external
                class="inline-flex w-full items-center justify-center rounded-full bg-blue-600 px-8 py-4 text-base font-medium text-white shadow-[0_0_20px_rgba(37,99,235,0.4)] transition-all hover:bg-blue-500 focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 focus:ring-offset-neutral-900 focus:outline-none active:scale-95 sm:w-auto"
              >
                {{ copy.dashboard }}
              </NuxtLink>
              <NuxtLink
                :to="viewerAppUrl"
                external
                class="inline-flex w-full items-center justify-center rounded-full border border-white/10 bg-white/10 px-8 py-4 text-base font-medium text-white backdrop-blur-md transition-all hover:bg-white/20 sm:w-auto"
              >
                {{ copy.watch }}
              </NuxtLink>
            </div>
          </div>
        </div>
      </div>
    </main>

    <UFooter>
      <template #left>
        <p class="text-muted text-sm">
          {{ copy.copyright }} © {{ new Date().getFullYear() }} Dino Kupinic
        </p>
      </template>

      <UNavigationMenu :items="items" variant="link" />

      <template #right>
        <UButton
          icon="i-simple-icons-github"
          color="neutral"
          variant="ghost"
          to="https://github.com/HTL-Steyr/tourney"
          target="_blank"
          aria-label="GitHub"
        />
      </template>
    </UFooter>
  </UPage>
</template>

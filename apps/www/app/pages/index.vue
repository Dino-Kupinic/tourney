<script setup lang="ts">
import type { PageFeatureProps, ButtonProps } from "@nuxt/ui"

// TODO: move to config
const adminAppUrl = "https://tourney-admin.dino-kupinic.dev"
const viewerAppUrl = "https://tourney-viewer.dino-kupinic.dev"
const demoVideoRef = ref<HTMLVideoElement | null>(null)
const isVideoPlaying = ref(false)

const playDemoVideo = async () => {
  if (!demoVideoRef.value) return

  try {
    await demoVideoRef.value.play()
    isVideoPlaying.value = true
  } catch {
    isVideoPlaying.value = false
  }
}

const syncVideoState = () => {
  if (!demoVideoRef.value) return
  isVideoPlaying.value = !demoVideoRef.value.paused
}

useSeoMeta({
  title: "Tourney - Tournament Management on Autopilot",
  description:
    "The platform that automatically manages brackets, crafts custom schedules, and runs events while your team does anything else.",
  ogTitle: "Tourney - Tournament Management on Autopilot",
  ogDescription:
    "The platform that automatically manages brackets, crafts custom schedules, and runs events while your team does anything else.",
  twitterCard: "summary_large_image",
})

useHead({
  htmlAttrs: {
    lang: "de",
  },
})

const items = [
  {
    label: "GitHub",
    to: "https://github.com/HTL-Steyr/tourney",
    target: "_blank",
  },
  {
    label: "Dino Kupinic",
    to: "https://dino-kupinic.dev",
    target: "_blank",
  },
  {
    label: "Releases",
    to: "https://github.com/HTL-Steyr/tourney/releases",
    target: "_blank",
  },
]

const cards = ref([
  {
    title: "Turniere planen und steuern",
    description:
      "Erstelle Fußball-, Volleyball- oder Basketballturniere mit Regeln, Zeitfenstern, Preisen und automatischer Gruppeneinteilung.",
    icon: "i-lucide-trophy",
    to: `${adminAppUrl}/tournaments`,
    target: "_blank",
    class: "lg:col-span-2",
    orientation: "horizontal" as const,
  },
  {
    title: "Live-Betrieb im Admin",
    description:
      "Starte Gruppenphasen, setze Matches live und aktualisiere Ergebnisse direkt während des Events.",
    icon: "i-lucide-signal",
    to: `${adminAppUrl}/live`,
    target: "_blank",
    variant: "soft" as const,
  },
  {
    title: "Anmeldungen und Teams",
    description:
      "Erstelle Registrierungslinks, verwalte Klassen-Teams und bearbeite den Status von Anmeldungen zentral.",
    icon: "i-lucide-ticket",
    to: `${adminAppUrl}/registration`,
    target: "_blank",
    variant: "soft" as const,
  },
  {
    title: "Live-Ansicht für Zuschauer",
    description:
      "Zeige Live-Spiele, Bracket-Visualisierung, Platzierungen und Ergebnisverlauf in Echtzeit.",
    icon: "i-lucide-monitor-play",
    to: `${viewerAppUrl}/live`,
    target: "_blank",
    class: "lg:col-span-2",
    orientation: "horizontal" as const,
    reverse: true,
  },
])

const features = ref<PageFeatureProps[]>([
  {
    title: "Turnierdetails für alle",
    description:
      "Alle Turniere mit Datum, Ort, Regeln und Preisen sind im Viewer öffentlich verfügbar.",
    icon: "i-lucide-calendar-days",
    to: `${viewerAppUrl}/tournaments`,
  },
  {
    title: "Live-Flow und Tabellen",
    description:
      "Der Turnierbaum, laufende Matches und Gruppenstände werden automatisch aktualisiert.",
    icon: "i-lucide-git-branch-plus",
    to: `${viewerAppUrl}/live`,
  },
  {
    title: "Medien und Updates",
    description:
      "News und Bilder lassen sich im Admin pflegen und direkt im Viewer veröffentlichen.",
    icon: "i-lucide-images",
    to: `${viewerAppUrl}/media`,
  },
])
const links = ref<ButtonProps[]>([
  {
    label: "Admin Dashboard öffnen",
    to: adminAppUrl,
    target: "_blank",
    color: "neutral",
    variant: "subtle",
    trailingIcon: "i-lucide-arrow-right",
  },
  {
    label: "Live Viewer öffnen",
    to: `${viewerAppUrl}/live`,
    target: "_blank",
    trailingIcon: "i-lucide-external-link",
  },
])
</script>

<template>
  <UPage>
    <main class="relative overflow-hidden pt-32 pb-24 md:pt-40">
      <div class="mx-auto max-w-7xl px-6 lg:px-8">
        <!-- Hero Section -->
        <div class="max-w-3xl">
          <h1
            class="mb-6 text-5xl leading-tight font-semibold tracking-tighter text-neutral-900 md:text-7xl"
          >
            Turniere veranstalten. <br />
            Ohne das Chaos.
          </h1>
          <p
            class="mb-10 max-w-2xl text-lg leading-tight text-neutral-500 md:text-xl"
          >
            Die Plattform, die komplexe Brackets verwaltet, maßgeschneiderte
            Spielpläne entwirft und die Organisation übernimmt, während sich
            dein Team auf alles andere konzentriert.
          </p>
          <div
            class="flex flex-col items-start gap-4 sm:flex-row sm:items-center"
          >
            <NuxtLink
              :to="viewerAppUrl"
              external
              class="inline-flex items-center justify-center rounded-full bg-blue-600 px-6 py-3 text-base font-medium text-white shadow-sm transition-all hover:bg-blue-700 focus:ring-2 focus:ring-blue-600 focus:ring-offset-2 focus:outline-none active:scale-95"
            >
              Zuschauen
            </NuxtLink>
            <NuxtLink
              :to="adminAppUrl"
              external
              class="inline-flex items-center justify-center rounded-full border border-neutral-200 bg-white px-6 py-3 text-base font-medium text-neutral-700 transition-all hover:border-neutral-300 hover:bg-neutral-50"
            >
              Dashboard
            </NuxtLink>
          </div>
        </div>

        <div id="video-demo" class="relative mt-20">
          <div
            class="group relative flex aspect-video w-full cursor-pointer items-center justify-center overflow-hidden rounded-3xl border border-neutral-800 bg-neutral-950 shadow-2xl"
          >
            <video
              ref="demoVideoRef"
              class="h-full w-full object-cover"
              src="/dkupinic-2.mp4"
              preload="metadata"
              playsinline
              controls
              @play="syncVideoState"
              @pause="syncVideoState"
              @ended="syncVideoState"
            />

            <button
              v-if="!isVideoPlaying"
              type="button"
              aria-label="Produktdemo abspielen"
              class="absolute inset-0 z-10 flex flex-col items-center justify-center gap-4 bg-neutral-950/40 transition-transform duration-300 group-hover:scale-105"
              @click="playDemoVideo"
            >
              <div
                class="flex h-20 w-20 items-center justify-center rounded-full border border-white/20 bg-white/10 text-white shadow-lg backdrop-blur-sm"
              >
                <svg
                  class="ml-1 h-8 w-8"
                  fill="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path d="M8 5v14l11-7z" />
                </svg>
              </div>
              <span class="text-sm font-medium tracking-wide text-white/60"
                >Demo</span
              >
            </button>

            <div
              class="pointer-events-none absolute top-0 right-0 left-0 flex h-12 items-center gap-2 border-b border-white/10 bg-neutral-950/50 px-6 backdrop-blur-md"
            >
              <div class="flex gap-2">
                <div class="h-3 w-3 rounded-full bg-red-500/80"></div>
                <div class="h-3 w-3 rounded-full bg-yellow-500/80"></div>
                <div class="h-3 w-3 rounded-full bg-green-500/80"></div>
              </div>
            </div>
          </div>
        </div>

        <div id="features" class="mt-32 border-t border-neutral-100 pt-16">
          <UPageGrid>
            <UPageCard
              v-for="(card, index) in cards"
              :key="index"
              v-bind="card"
            >
            </UPageCard>
          </UPageGrid>
        </div>

        <div class="mt-32">
          <UPageSection
            title="Alles für den Turniertag"
            description="Vom Anmeldeprozess bis zur Live-Auswertung arbeiten Admin und Viewer in einer gemeinsamen Plattform zusammen."
            icon="i-lucide-layout-dashboard"
            orientation="horizontal"
            :features="features"
            :links="links"
          >
            <NuxtImg
              src="/football.jpg"
              width="600"
              height="700"
              alt="Illustration"
              class="w-full rounded-lg"
              loading="lazy"
            />
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
              Bereit, deine Turniere auf das nächste Level zu bringen?
            </h2>
            <p class="mx-auto mb-10 max-w-xl text-lg text-neutral-400">
              Erstelle dein erstes Turnier in Sekunden und erlebe, wie Tourney
              die Organisation übernimmt, damit du dich auf das Wesentliche
              konzentrieren kannst
            </p>
            <div
              class="flex flex-col items-center justify-center gap-4 sm:flex-row"
            >
              <NuxtLink
                :to="adminAppUrl"
                external
                class="inline-flex w-full items-center justify-center rounded-full bg-blue-600 px-8 py-4 text-base font-medium text-white shadow-[0_0_20px_rgba(37,99,235,0.4)] transition-all hover:bg-blue-500 focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 focus:ring-offset-neutral-900 focus:outline-none active:scale-95 sm:w-auto"
              >
                Dashboard
              </NuxtLink>
              <NuxtLink
                :to="viewerAppUrl"
                external
                class="inline-flex w-full items-center justify-center rounded-full border border-white/10 bg-white/10 px-8 py-4 text-base font-medium text-white backdrop-blur-md transition-all hover:bg-white/20 sm:w-auto"
              >
                Zuschauen
              </NuxtLink>
            </div>
          </div>
        </div>
      </div>
    </main>

    <UFooter>
      <template #left>
        <p class="text-muted text-sm">
          Copyright © {{ new Date().getFullYear() }} Dino Kupinic
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

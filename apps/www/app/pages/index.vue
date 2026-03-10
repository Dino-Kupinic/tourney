<script setup lang="ts">
const adminAppUrl = "http://localhost:3000"
const viewerAppUrl = "http://localhost:3001"
const currentYear = new Date().getFullYear()
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
    label: "Figma Kit",
    to: "https://go.nuxt.com/figma-ui",
    target: "_blank",
  },
  {
    label: "Playground",
    to: "https://stackblitz.com/edit/nuxt-ui",
    target: "_blank",
  },
  {
    label: "Releases",
    to: "https://github.com/nuxt/ui/releases",
    target: "_blank",
  },
]
</script>

<template>
  <UPage>
    <header
      class="fixed top-0 right-0 left-0 z-50 border-b border-neutral-100 bg-white/80 backdrop-blur-md"
    >
      <div class="mx-auto max-w-7xl px-6 lg:px-8">
        <div class="flex h-16 items-center justify-between">
          <div class="flex items-center gap-8">
            <NuxtLink to="/" class="flex items-center gap-2">
              <span class="text-xl font-bold tracking-tight">Tourney</span>
            </NuxtLink>
            <nav class="hidden items-center gap-6 md:flex">
              <NuxtLink
                to="#features"
                class="text-sm font-medium text-neutral-600 transition-colors hover:text-neutral-900"
                >Produkt</NuxtLink
              >
              <NuxtLink
                to="#how-it-works"
                class="text-sm font-medium text-neutral-600 transition-colors hover:text-neutral-900"
                >Ressourcen</NuxtLink
              >
            </nav>
          </div>
          <div class="flex items-center gap-4">
            <NuxtLink
              :to="adminAppUrl"
              external
              class="hidden text-sm font-medium text-neutral-600 transition-colors hover:text-neutral-900 sm:block"
              >Dashboard</NuxtLink
            >
            <NuxtLink
              :to="viewerAppUrl"
              external
              class="rounded-full bg-blue-600 px-4 py-2 text-sm font-medium text-white transition-all hover:bg-blue-700 active:scale-95"
            >
              Zuschauer
            </NuxtLink>
          </div>
        </div>
      </div>
    </header>

    <!-- Main Content -->
    <main class="relative overflow-hidden pt-40 pb-24 md:pt-48">
      <!-- Glow Effect -->
      <div
        class="absolute inset-0 -z-10 bg-[radial-gradient(ellipse_80%_80%_at_50%_-20%,rgba(37,99,235,0.15),rgba(255,255,255,0))]"
      ></div>

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
              <span
                class="text-sm font-medium tracking-wide text-white/60 uppercase"
                >Product Demo</span
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

        <!-- Features Section -->
        <div id="features" class="mt-32 border-t border-neutral-100 pt-16">
          <div class="mb-16 text-center">
            <h2
              class="mb-4 text-3xl font-semibold tracking-tight text-neutral-900 md:text-5xl"
            >
              Alles, was du für makellose Turniere brauchst
            </h2>
            <p class="mx-auto max-w-2xl text-lg text-neutral-500">
              Gebaut für Geschwindigkeit, Skalierbarkeit und Einfachheit. Wir
              übernehmen die harte Arbeit, damit du dich auf die Spieler und den
              Wettbewerb konzentrieren kannst.
            </p>
          </div>

          <div class="grid grid-cols-1 gap-8 md:grid-cols-3">
            <!-- Feature 1 -->
            <div
              class="group rounded-3xl border border-neutral-100 bg-neutral-50/50 p-8 transition-colors hover:border-blue-100 hover:bg-blue-50/30"
            >
              <div
                class="mb-6 flex h-12 w-12 items-center justify-center rounded-xl bg-blue-100 text-blue-600 transition-transform group-hover:scale-110"
              >
                <svg
                  class="h-6 w-6"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 002-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"
                  />
                </svg>
              </div>
              <h3 class="mb-3 text-xl font-semibold text-neutral-900">
                Automatisierte Spielpläne
              </h3>
              <p class="leading-relaxed text-neutral-500">
                Intelligente Algorithmen stellen sicher, dass deine besten
                Spieler im Finale und nicht in der ersten Runde
                aufeinandertreffen.
              </p>
            </div>

            <!-- Feature 2 -->
            <div
              class="group rounded-3xl border border-neutral-100 bg-neutral-50/50 p-8 transition-colors hover:border-blue-100 hover:bg-blue-50/30"
            >
              <div
                class="mb-6 flex h-12 w-12 items-center justify-center rounded-xl bg-blue-100 text-blue-600 transition-transform group-hover:scale-110"
              >
                <svg
                  class="h-6 w-6"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"
                  />
                </svg>
              </div>
              <h3 class="mb-3 text-xl font-semibold text-neutral-900">
                Echtzeit-Tabellen
              </h3>
              <p class="leading-relaxed text-neutral-500">
                Live-Ranglisten und Bracket-Ergebnisse werden direkt auf die
                Geräte der Spieler übertragen. Kein ständiges Neuladen von
                Seiten oder Gedränge um ausgedruckte Pläne mehr.
              </p>
            </div>

            <!-- Feature 3 -->
            <div
              class="group rounded-3xl border border-neutral-100 bg-neutral-50/50 p-8 transition-colors hover:border-blue-100 hover:bg-blue-50/30"
            >
              <div
                class="mb-6 flex h-12 w-12 items-center justify-center rounded-xl bg-blue-100 text-blue-600 transition-transform group-hover:scale-110"
              >
                <svg
                  class="h-6 w-6"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"
                  />
                </svg>
              </div>
              <h3 class="mb-3 text-xl font-semibold text-neutral-900">
                Verwaltung
              </h3>
              <p class="leading-relaxed text-neutral-500">
                Verwalte Anmeldungen, Turniere, usw. mit nur wenigen Klicks.
                Halte Teilnehmer mit Neuigkeiten up-to-date.
              </p>
            </div>
          </div>
        </div>

        <!-- How it Works Section -->
        <div id="how-it-works" class="mt-32">
          <div class="flex flex-col items-center gap-16 md:flex-row">
            <div class="flex-1">
              <span
                class="mb-4 block text-sm font-semibold tracking-wide text-blue-600 uppercase"
                >Wie es funktioniert</span
              >
              <h2
                class="mb-6 text-3xl font-semibold tracking-tight text-neutral-900 md:text-5xl"
              >
                Vom Konzept zum Champion in drei Schritten
              </h2>

              <div class="mt-10 space-y-8">
                <div class="flex gap-4">
                  <div
                    class="flex h-8 w-8 flex-shrink-0 items-center justify-center rounded-full bg-blue-100 text-sm font-bold text-blue-600"
                  >
                    1
                  </div>
                  <div>
                    <h4 class="text-lg font-semibold text-neutral-900">
                      Turnier erstellen
                    </h4>
                    <p class="mt-1 text-neutral-500">
                      Definiere Startdatum, Regeln, Turnierart, Preise und mehr.
                    </p>
                  </div>
                </div>
                <div class="flex gap-4">
                  <div
                    class="flex h-8 w-8 flex-shrink-0 items-center justify-center rounded-full bg-blue-100 text-sm font-bold text-blue-600"
                  >
                    2
                  </div>
                  <div>
                    <h4 class="text-lg font-semibold text-neutral-900">
                      Anmeldungen erstellen und teilen
                    </h4>
                    <p class="mt-1 text-neutral-500">
                      Erstelle und versende die Links. Spieler registrieren
                      sich, bilden Teams und verwalten ihre eigenen Check-ins in
                      der Zuschauer App.
                    </p>
                  </div>
                </div>
                <div class="flex gap-4">
                  <div
                    class="flex h-8 w-8 flex-shrink-0 items-center justify-center rounded-full bg-blue-100 text-sm font-bold text-blue-600"
                  >
                    3
                  </div>
                  <div>
                    <h4 class="text-lg font-semibold text-neutral-900">
                      Lass Tourney die Arbeit machen
                    </h4>
                    <p class="mt-1 text-neutral-500">
                      Gehe live und sobald die Matches beginnen, zieht Tourney
                      automatisch Sieger vor, benachrichtigt nächste Spieler und
                      berechnet Tabellenstände.
                    </p>
                  </div>
                </div>
              </div>
            </div>

            <div
              class="relative aspect-square w-full flex-1 overflow-hidden rounded-3xl border border-neutral-200 bg-neutral-100 md:aspect-[4/5]"
            >
              <!-- Decorative abstract representation of workflow -->
              <div
                class="absolute top-10 right-10 bottom-10 left-10 flex flex-col gap-4 rounded-2xl border border-neutral-200 bg-white p-6 shadow-sm"
              >
                <div class="h-4 w-1/3 rounded-full bg-neutral-200"></div>
                <div
                  class="flex h-24 w-full items-center gap-4 rounded-xl border border-neutral-100 bg-neutral-50 px-4"
                >
                  <div class="h-10 w-10 rounded-full bg-blue-100"></div>
                  <div class="flex-1 space-y-2">
                    <div class="h-3 w-1/2 rounded-full bg-neutral-200"></div>
                    <div class="h-2 w-1/4 rounded-full bg-neutral-200"></div>
                  </div>
                  <div class="h-8 w-16 rounded-lg bg-neutral-900"></div>
                </div>
                <div
                  class="flex h-24 w-full items-center gap-4 rounded-xl border border-neutral-100 bg-neutral-50 px-4"
                >
                  <div class="h-10 w-10 rounded-full bg-blue-100"></div>
                  <div class="flex-1 space-y-2">
                    <div class="h-3 w-1/2 rounded-full bg-neutral-200"></div>
                    <div class="h-2 w-1/4 rounded-full bg-neutral-200"></div>
                  </div>
                  <div
                    class="h-8 w-16 rounded-lg bg-white outline outline-1 outline-neutral-200"
                  ></div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Final CTA Section -->
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
          icon="i-simple-icons-discord"
          color="neutral"
          variant="ghost"
          to="https://go.nuxt.com/discord"
          target="_blank"
          aria-label="Discord"
        />
        <UButton
          icon="i-simple-icons-x"
          color="neutral"
          variant="ghost"
          to="https://go.nuxt.com/x"
          target="_blank"
          aria-label="X"
        />
        <UButton
          icon="i-simple-icons-github"
          color="neutral"
          variant="ghost"
          to="https://github.com/nuxt/nuxt"
          target="_blank"
          aria-label="GitHub"
        />
      </template>
    </UFooter>
  </UPage>
</template>

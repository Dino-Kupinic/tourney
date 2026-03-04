<script setup lang="ts">
import { createAvatar } from "@dicebear/core"
import { glass } from "@dicebear/collection"

const { name, role } = useUser()
const route = useRoute()
const svg = computed(() =>
  createAvatar(glass, {
    seed: name.value,
  }).toDataUri(),
)
// TODO: make navbar rerender on live tournament change
const { liveTournaments, fetchLiveTournaments } = useLiveTournaments()
await fetchLiveTournaments()

function isActive(to: string) {
  if (to === "/") {
    return route.path === to
  }

  return route.path === to || route.path.startsWith(`${to}/`)
}

const navigationLinks = computed(() => [
  [
    {
      label: "Home",
      icon: "i-heroicons-home",
      to: "/",
      exact: true,
      active: isActive("/"),
    },
    {
      label: "Dashboard",
      icon: "i-heroicons-chart-bar",
      to: "/dashboard",
      exact: true,
      active: isActive("/dashboard"),
    },
  ],
  [
    {
      label: "Live",
      icon: "i-heroicons-signal",
      badge:
        liveTournaments.value > 0
          ? {
              label: liveTournaments.value,
              color: "error",
              variant: "outline",
            }
          : undefined,
      to: "/live",
      exact: true,
      active: isActive("/live"),
    },
    {
      label: "Turniere",
      icon: "i-heroicons-trophy",
      to: "/tournaments",
      exact: true,
      active: isActive("/tournaments"),
    },
    {
      label: "Anmeldung",
      icon: "i-heroicons-ticket",
      to: "/registration",
      exact: true,
      active: isActive("/registration"),
    },
  ],
  [
    {
      label: "Aktuelles",
      icon: "i-heroicons-newspaper",
      to: "/news",
      exact: true,
      active: isActive("/news"),
    },
    {
      label: "Galerie",
      icon: "i-heroicons-photo",
      to: "/gallery",
      exact: true,
      active: isActive("/gallery"),
    },
  ],
  [
    {
      label: "Aktivität",
      icon: "i-heroicons-queue-list",
      to: "/logs",
      exact: true,
      active: isActive("/logs"),
    },
    {
      label: "Verwaltung",
      icon: "i-heroicons-squares-2x2",
      to: "/management",
      exact: true,
      active: isActive("/management"),
    },
  ],
])

const settingsLinks = computed(() => [
  {
    label: "Einstellungen",
    icon: "i-heroicons-cog-8-tooth",
    to: "/settings",
    exact: true,
    active: isActive("/settings"),
  },
])
</script>

<template>
  <UDashboardSidebar
    id="navigation"
    :default-size="12"
    :min-size="12"
    :max-size="16"
    resizable
    :toggle="{ color: 'neutral', variant: 'ghost', size: 'sm' }"
    :ui="{
      root: 'h-full !min-h-0 rounded-md border border-neutral-200 bg-white dark:border-neutral-800 dark:bg-neutral-900',
      header: 'px-3 py-3',
      body: 'gap-2 px-2 py-2',
      footer: 'border-t border-neutral-200 px-2 py-2 dark:border-neutral-800',
      content: 'bg-white dark:bg-neutral-900',
    }"
  >
    <template #header>
      <NuxtLink to="/" class="flex items-center gap-3 px-1">
        <Logo class="h-8 w-8 shrink-0" />
        <div class="min-w-0">
          <p
            class="truncate text-sm font-semibold text-neutral-950 dark:text-white"
          >
            Tourney
          </p>
          <p class="text-xs text-neutral-500 dark:text-neutral-400">Admin</p>
        </div>
      </NuxtLink>
    </template>

    <UDashboardSearchButton variant="soft" :kbds="['meta', 'k']" />

    <UNavigationMenu
      :items="navigationLinks"
      orientation="vertical"
      color="neutral"
      class="grow"
    />

    <template #footer>
      <div class="w-full">
        <div class="space-y-2">
          <div class="flex items-center gap-2 rounded-lg px-3 py-2">
            <img
              :src="svg"
              :alt="name"
              class="h-5 w-5 rounded-full bg-neutral-100 object-cover dark:bg-neutral-800"
            />
            <div class="flex min-w-0 items-center gap-2">
              <p
                class="truncate text-sm font-semibold text-neutral-500 dark:text-neutral-300"
              >
                {{ name }}
              </p>
              <UBadge color="primary" variant="subtle" size="sm">
                {{ role }}
              </UBadge>
            </div>
          </div>
        </div>

        <UNavigationMenu
          :items="settingsLinks"
          orientation="vertical"
          color="neutral"
          class="grow"
        />
      </div>
    </template>
  </UDashboardSidebar>
</template>

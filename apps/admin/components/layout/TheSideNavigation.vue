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

const navigationLinks = [
  [
    {
      label: "Home",
      icon: "i-heroicons-home",
      to: "/",
    },
    {
      label: "Dashboard",
      icon: "i-heroicons-chart-bar",
      to: "/dashboard",
    },
  ],
  [
    {
      label: "Live",
      icon: "i-heroicons-signal",
      badge: liveTournaments.value,
      to: "/live",
    },
    {
      label: "Turniere",
      icon: "i-heroicons-trophy",
      to: "/tournaments",
    },
    {
      label: "Anmeldung",
      icon: "i-heroicons-ticket",
      to: "/registration",
    },
  ],
  [
    {
      label: "Aktuelles",
      icon: "i-heroicons-newspaper",
      to: "/news",
    },
    {
      label: "Galerie",
      icon: "i-heroicons-photo",
      to: "/gallery",
    },
  ],
  [
    {
      label: "Aktivität",
      icon: "i-heroicons-queue-list",
      to: "/logs",
    },
    {
      label: "Verwaltung",
      icon: "i-heroicons-squares-2x2",
      to: "/management",
    },
  ],
]

function isActive(to: string) {
  if (to === "/") {
    return route.path === to
  }

  return route.path === to || route.path.startsWith(`${to}/`)
}
</script>

<template>
  <UDashboardSidebar
    id="navigation"
    :default-size="14"
    :min-size="12"
    :max-size="18"
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

    <nav class="flex grow flex-col gap-2">
      <div
        v-for="(section, sectionIndex) in navigationLinks"
        :key="sectionIndex"
        class="space-y-0.5 border-b border-neutral-200 pb-3 dark:border-neutral-800"
        :class="
          sectionIndex === navigationLinks.length - 1 && 'border-b-0 pb-0'
        "
      >
        <NuxtLink
          v-for="item in section"
          :key="item.to"
          :to="item.to"
          class="flex items-center justify-between rounded-lg px-3 py-1 text-sm font-medium transition-colors"
          :class="
            isActive(item.to)
              ? 'bg-neutral-100 text-neutral-950 dark:bg-neutral-800/70 dark:text-white'
              : 'text-neutral-500 hover:bg-neutral-100/70 hover:text-neutral-900 dark:text-neutral-400 dark:hover:bg-neutral-800/60 dark:hover:text-white'
          "
        >
          <span class="flex min-w-0 items-center gap-2">
            <UIcon :name="item.icon" class="h-4 w-4 shrink-0" />
            <span class="truncate">{{ item.label }}</span>
          </span>
          <UBadge v-if="item.badge" color="error" variant="outline">
            {{ item.badge }}
          </UBadge>
        </NuxtLink>
      </div>
    </nav>

    <template #footer>
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

        <NuxtLink
          to="/settings"
          class="flex items-center gap-2 rounded-lg px-3 py-1 text-sm font-medium transition-colors"
          :class="
            isActive('/settings')
              ? 'bg-neutral-100 text-neutral-950 dark:bg-neutral-800/70 dark:text-white'
              : 'text-neutral-500 hover:bg-neutral-100/70 hover:text-neutral-900 dark:text-neutral-400 dark:hover:bg-neutral-800/60 dark:hover:text-white'
          "
        >
          <UIcon name="i-heroicons-cog-8-tooth" class="h-4 w-4 shrink-0" />
          <span>Einstellungen</span>
        </NuxtLink>
      </div>
    </template>
  </UDashboardSidebar>
</template>

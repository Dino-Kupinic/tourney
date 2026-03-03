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
  <aside class="flex h-full min-w-64 flex-col gap-4 pb-2">
    <nav class="flex grow flex-col pr-2">
      <template
        v-for="(section, sectionIndex) in navigationLinks"
        :key="sectionIndex"
      >
        <div class="space-y-0.5">
          <NuxtLink
            v-for="item in section"
            :key="item.to"
            :to="item.to"
            class="flex items-center justify-between rounded-md px-3 py-1.5 text-sm font-medium transition-colors"
            :class="
              isActive(item.to)
                ? 'bg-gray-200 text-gray-950 dark:bg-gray-800 dark:text-white'
                : 'text-gray-700 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-800/80'
            "
          >
            <span class="flex items-center gap-2">
              <UIcon :name="item.icon" class="h-4 w-4 shrink-0" />
              <span>{{ item.label }}</span>
            </span>
            <UBadge
              v-if="item.badge"
              color="neutral"
              variant="outline"
              class="!bg-white !text-gray-700 ring-1 ring-gray-200 dark:!bg-gray-950 dark:!text-gray-200 dark:ring-gray-800"
            >
              {{ item.badge }}
            </UBadge>
          </NuxtLink>
        </div>
        <USeparator
          v-if="sectionIndex < navigationLinks.length - 1"
          class="my-3 mr-2"
        />
      </template>
    </nav>

    <div
      class="mr-2 flex items-center gap-3 rounded-lg border border-gray-200 bg-white px-3 py-2 dark:border-gray-800 dark:bg-gray-900"
    >
      <img
        :src="svg"
        :alt="name"
        class="h-9 w-9 rounded-md border border-gray-200 bg-gray-100 object-cover dark:border-gray-700 dark:bg-gray-800"
      />
      <div class="flex min-w-0 items-center gap-2">
        <p class="truncate text-sm font-semibold text-gray-950 dark:text-white">
          {{ name }}
        </p>
        <UBadge
          color="neutral"
          variant="outline"
          class="!bg-white !text-gray-700 ring-1 ring-gray-200 dark:!bg-gray-950 dark:!text-gray-200 dark:ring-gray-800"
        >
          {{ role }}
        </UBadge>
      </div>
    </div>

    <NuxtLink
      to="/settings"
      class="mr-2 flex items-center gap-2 rounded-lg px-3 py-2 text-sm font-medium text-gray-700 transition-colors hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-800/80"
      :class="
        isActive('/settings') &&
        'bg-gray-200 text-gray-950 dark:bg-gray-800 dark:text-white'
      "
    >
      <UIcon name="i-heroicons-cog-8-tooth" class="h-4 w-4 shrink-0" />
      <span>Einstellungen</span>
    </NuxtLink>
  </aside>
</template>

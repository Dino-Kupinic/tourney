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
  <aside class="flex h-full max-w-44 min-w-44 flex-col pb-2">
    <nav class="flex grow flex-col gap-2 pr-2">
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
          <span class="flex items-center gap-2">
            <UIcon :name="item.icon" class="h-4 w-4 shrink-0" />
            <span>{{ item.label }}</span>
          </span>
          <UBadge
            v-if="item.badge"
            color="error"
            variant="outline"
            class="!text-error ring-error/20 h-5 min-w-5 rounded-md !bg-white px-1.5 !text-[10px] !font-medium ring-1 dark:!bg-neutral-950"
          >
            {{ item.badge }}
          </UBadge>
        </NuxtLink>
      </div>
    </nav>

    <div class="mt-2 mr-2">
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
  </aside>
</template>

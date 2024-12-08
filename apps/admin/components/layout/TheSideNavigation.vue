<script setup lang="ts">
import type { VerticalNavigationLink } from "#ui/types"
import { createAvatar } from "@dicebear/core"
import { glass } from "@dicebear/collection"

const { name, role } = useUser()
const avatar = createAvatar(glass, {
  seed: name.value,
})
const svg = avatar.toDataUri()
const liveTournaments = ref<number>(3)

const navigationLinks: VerticalNavigationLink[][] = [
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
  ],
]

const profileLinks: VerticalNavigationLink[] = [
  {
    label: name.value,
    avatar: {
      src: svg,
    },
    badge: role.value,
  },
  {
    label: "Einstellungen",
    icon: "i-heroicons-cog-8-tooth",
    to: "/settings",
  },
]
</script>

<template>
  <div class="flex h-full min-w-44 flex-col pb-2">
    <UVerticalNavigation
      :links="navigationLinks"
      :ui="{
        wrapper: 'mr-2 grow',
        badge: {
          // @ts-ignore
          color: 'red',
          // @ts-ignore
          variant: 'subtle',
        },
      }"
    />
    <UVerticalNavigation
      :links="profileLinks"
      :ui="{
        wrapper: 'mr-2',
        badge: {
          // @ts-ignore
          color: 'primary',
          // @ts-ignore
          variant: 'subtle',
        },
      }"
    />
  </div>
</template>

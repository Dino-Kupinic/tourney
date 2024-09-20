<script setup lang="ts">
import { createAvatar } from "@dicebear/core"
import { glass } from "@dicebear/collection"

const user = ref<string>("Dino Kupinic")
const avatar = createAvatar(glass, {
  seed: user.value,
})
const svg = avatar.toDataUri()
const liveTournaments = ref<number>(3)

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
      label: "Formate",
      icon: "i-heroicons-table-cells",
      to: "/formats",
    },
    {
      label: "Anmeldung",
      icon: "i-heroicons-ticket",
      to: "/registration",
    },
  ],
  [
    {
      label: "Preise",
      icon: "i-heroicons-gift",
      to: "/prices",
    },
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
      label: "Nutzer",
      icon: "i-heroicons-users",
      to: "/users",
    },
  ],
]

const profileLinks = [
  {
    label: user.value,
    avatar: {
      src: svg,
    },
    badge: "Admin",
  },
  {
    label: "Einstellungen",
    icon: "i-heroicons-cog-8-tooth",
    to: "/settings",
  },
]
</script>

<template>
  <div class="flex h-full flex-col pb-2">
    <UVerticalNavigation
      :links="navigationLinks"
      :ui="{
        wrapper: 'mr-2 grow',
        badge: {
          color: 'red',
          variant: 'subtle',
        },
      }"
    />
    <UVerticalNavigation
      :links="profileLinks"
      :ui="{
        wrapper: 'mr-2',
        badge: {
          color: 'primary',
          variant: 'subtle',
        },
      }"
    />
  </div>
</template>

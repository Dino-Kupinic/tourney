<script setup lang="ts">
import { createAvatar } from "@dicebear/core";
import { glass } from "@dicebear/collection";

const user = ref("Dino Kupinic");
const avatar = createAvatar(glass, {
  seed: user.value,
});
const svg = avatar.toDataUri();

const links = [
  [
    {
      label: "Live",
      icon: "i-heroicons-signal",
      badge: 3,
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
      icon: "i-heroicons-users",
      to: "/registration",
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
  ],
];
</script>

<template>
  <UVerticalNavigation
    :links="links"
    :ui="{
      wrapper: 'flex flex-col justify-between mr-2 pb-2',
      badge: {
        color: 'primary',
        variant: 'subtle',
      },
      divider: {
        type: 'dashed',
      },
    }"
  />
</template>

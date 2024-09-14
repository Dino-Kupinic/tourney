<script setup lang="ts">
const appVersion = useAppVersion();
const stage = "Alpha";
</script>

<template>
  <nav class="w-full flex justify-between items-center">
    <div class="items-center flex gap-1 p-1 pr-0 justify-end w-full">
      <UBadge
        color="green"
        size="xs"
        variant="subtle"
        class="font-mono tracking-tight"
      >
        Database connected
      </UBadge>
      <UBadge
        color="purple"
        size="xs"
        variant="subtle"
        class="font-mono tracking-tight"
      >
        376 Users
      </UBadge>
      <UBadge color="white" size="xs" class="font-mono tracking-tight">
        TOURNEY v{{ appVersion }} {{ stage }}
      </UBadge>
    </div>
  </nav>
</template>

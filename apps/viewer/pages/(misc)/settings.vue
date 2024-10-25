<script setup lang="ts">
useHead({
  title: "Einstellungen",
})
</script>

<template>
  <PageHeader
    title="Einstellungen"
    description="Hier kannst du deine Präferenzen einstellen"
  />
  <UCard>
    <template #header> Aussehen </template>
    <BaseSettingsItem>
      <div class="flex items-center justify-between">
        <strong>Modus</strong>
        <ThemeButton />
      </div>
    </BaseSettingsItem>
  </UCard>
</template>

<style scoped></style>

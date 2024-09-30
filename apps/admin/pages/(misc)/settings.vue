<script setup lang="ts">
import BaseSettingsItem from "~/components/settings/BaseSettingsItem.vue"

const title = ref<string>("Einstellungen")
useHead({
  title: () => title.value,
})

const { name, role, email, last_sign_in, logout } = useUser()

const onLogout = async () => {
  await logout()
  return navigateTo("/login")
}
</script>

<template>
  <BasePageHeader :title="title"></BasePageHeader>
  <main
    class="m-auto mt-4 flex h-full max-w-[600px] flex-col space-y-3 overflow-y-auto p-2"
  >
    <UCard>
      <template #header> Aussehen </template>
      <BaseSettingsItem>
        <div class="flex items-center justify-between">
          <strong>Modus</strong>
          <ThemeButton />
        </div>
      </BaseSettingsItem>
    </UCard>
    <UCard>
      <template #header> Account </template>
      <BaseSettingsItem>
        <strong>{{ name }}</strong>
        <UBadge variant="subtle" class="float-right">{{ role }}</UBadge>
        <p>{{ email }}</p>
        <p class="text-right text-sm text-gray-400 dark:text-gray-500">
          Zuletzt eingeloggt:
          {{ last_sign_in }}
        </p>
      </BaseSettingsItem>
      <template #footer>
        <UButton label="Logout" @click="onLogout()" />
      </template>
    </UCard>
  </main>
</template>

<style scoped></style>

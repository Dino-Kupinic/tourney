<script setup lang="ts">
const title = ref<string>("Einstellungen")
useHead({
  title: () => title.value,
})

const { name, logout } = useUser()

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
      <div>
        <div class="flex items-center justify-between">
          <strong>Modus</strong>
          <ThemeButton />
        </div>
      </div>
    </UCard>
    <UCard>
      <template #header> Account </template>
      <template #footer>
        <UButton label="Logout" @click="onLogout()" />
      </template>
    </UCard>
  </main>
</template>

<style scoped></style>

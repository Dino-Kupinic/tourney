<script setup lang="ts">
const title = ref<string>("Home")
useHead({
  title: () => title.value,
})

const options = [
  {
    label: "Live",
    color: "bg-red-100 text-red-500",
  },
  {
    label: "Dashboard",
    color: "bg-orange-100 text-orange-500",
  },
  {
    label: "Turniere",
    color: "bg-yellow-100 text-yellow-500",
  },
  {
    label: "Anmeldung",
    color: "bg-lime-100 text-lime-500",
  },
  {
    label: "Aktuelles",
    color: "bg-green-100 text-green-500",
  },
  {
    label: "Galerie",
    color: "bg-purple-100 text-purple-500",
  },
  {
    label: "Aktivität",
    color: "bg-cyan-100 text-cyan-500",
  },
  {
    label: "Verwaltung",
    color: "bg-blue-100 text-blue-500",
  },
  {
    label: "Einstellungen",
    color: "bg-rose-100 text-rose-500",
  },
]
</script>

<template>
  <BasePageHeader :title="title" />
  <BasePageContent>
    <div class="flex h-full w-full items-center justify-center">
      <div
        class="h-[32rem] w-[48rem] rounded-2xl bg-gray-100 p-12 dark:bg-gray-800"
      >
        <h1 class="font-serif text-3xl tracking-tight">
          Willkommen bei tourney.
        </h1>
        <div class="flex h-full w-full flex-col space-y-3">
          <h2 class="mt-6 font-mono tracking-tight">QUICKSTART</h2>
          <div class="flex grow gap-12">
            <div class="grow space-y-2">
              <div class="rounded-md border border-gray-200 bg-gray-50 p-2">
                GitHub
              </div>
              <div class="rounded-md border border-gray-200 bg-gray-50 p-2">
                Schülerapp
              </div>
              <div class="rounded-md border border-gray-200 bg-gray-50 p-2">
                Dokumentation
              </div>
            </div>
            <div class="grid w-full shrink grid-cols-3 gap-2">
              <div
                v-for="option in options"
                :key="option.label"
                :class="[option.color]"
                class="flex h-28 w-full flex-col items-center justify-center gap-1 rounded-lg font-medium"
              >
                <p>{{ option.label }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </BasePageContent>
</template>

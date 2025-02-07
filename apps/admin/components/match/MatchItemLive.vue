<script setup lang="ts">
const timeElapsed = ref<number>(0)
const isRunning = ref<boolean>(false)

const { resume } = useIntervalFn(
  () => {
    timeElapsed.value++
  },
  1000,
  { immediate: true },
)

const startStopwatch = () => {
  isRunning.value = true
  resume()
}
startStopwatch()

const formattedTime = computed(() => {
  const minutes = Math.floor(timeElapsed.value / 60)
  const seconds = timeElapsed.value % 60
  return `${String(minutes).padStart(2, "0")}:${String(seconds).padStart(2, "0")}`
})

const score1 = ref<number>(2)
const score2 = ref<number>(0)
</script>

<template>
  <div
    class="flex w-96 flex-col items-center justify-between gap-1 rounded-md border border-gray-200 px-6 py-3 shadow-sm dark:border-gray-700"
  >
    <div>
      <p class="font-mono text-xs">Gruppenphase - {{ formattedTime }}</p>
      <p class="text-center text-xs italic text-gray-500">gestartet um 11:30</p>
    </div>
    <div class="flex w-full items-center justify-between">
      <div class="flex flex-col items-center space-y-1">
        <UIcon name="i-game-icons-heartburn" size="36" />
        <p class="text-xs">1AHITN</p>
        <div class="space-x-0.5">
          <UButton
            :ui="{ rounded: 'rounded-full' }"
            size="2xs"
            color="gray"
            square
            icon="i-heroicons-minus"
            @click="score1--"
          />
          <UButton
            :ui="{ rounded: 'rounded-full' }"
            size="2xs"
            color="gray"
            square
            icon="i-heroicons-plus"
            @click="score1++"
          />
        </div>
      </div>
      <div class="flex items-center gap-5">
        <p class="text-4xl font-bold">{{ score1 }}</p>
        <p>vs</p>
        <p class="text-4xl font-bold">{{ score2 }}</p>
      </div>
      <div class="flex flex-col items-center space-y-1">
        <UIcon name="i-game-icons-dragon-head" size="36" />
        <p class="text-xs">2AHITN</p>
        <div class="space-x-0.5">
          <UButton
            :ui="{ rounded: 'rounded-full' }"
            size="2xs"
            color="gray"
            square
            icon="i-heroicons-minus"
            @click="score2--"
          />
          <UButton
            :ui="{ rounded: 'rounded-full' }"
            size="2xs"
            color="gray"
            square
            icon="i-heroicons-plus"
            @click="score2++"
          />
        </div>
      </div>
    </div>
    <UButton
      icon="i-heroicons-hand-raised"
      variant="soft"
      color="fuchsia"
      label="Spiel beenden..."
      size="2xs"
    />
  </div>
</template>

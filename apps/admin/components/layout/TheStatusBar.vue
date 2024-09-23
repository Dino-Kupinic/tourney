<script setup lang="ts">
const appVersion = useAppVersion()

const isOnline = useOnline()
const { isSupported, memory } = useMemory()
const formatted = useDateFormat(useNow(), "dddd HH:mm:ss")

function size(v: number) {
  const kb = v / 1024 / 1024
  return `${kb.toFixed(2)} MB`
}
</script>

<template>
  <nav class="flex w-full items-center justify-between">
    <div
      class="flex w-full items-center justify-end gap-1 p-1 pr-0 font-mono tracking-tight"
    >
      <UBadge v-if="isOnline" color="green" size="xs" variant="subtle">
        Online
      </UBadge>
      <UBadge v-else color="red" size="xs" variant="subtle"> Offline </UBadge>
      <UBadge color="purple" size="xs" variant="subtle">
        {{ formatted }}
      </UBadge>
      <UBadge
        v-if="isSupported && memory"
        color="yellow"
        size="xs"
        variant="subtle"
      >
        {{ size(memory.usedJSHeapSize) }}
      </UBadge>
      <UBadge
        v-else-if="!isSupported && !memory"
        color="yellow"
        size="xs"
        variant="subtle"
      >
        Nicht Unterstützt
      </UBadge>
      <UBadge v-else color="yellow" size="xs" variant="subtle">
        Kalkuliere...
      </UBadge>
      <UBadge color="white" size="xs"> tourney v{{ appVersion }} </UBadge>
    </div>
  </nav>
</template>

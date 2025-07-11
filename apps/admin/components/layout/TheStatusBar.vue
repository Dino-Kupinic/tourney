<script setup lang="ts">
const appVersion = useAppVersion()

const isOnline = useOnline()
const { isSupported, memory } = useMemory()

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
        <NuxtTime
          :datetime="Date.now()"
          year="numeric"
          month="long"
          day="numeric"
          hour="2-digit"
          locale="de-DE"
          minute="2-digit"
        />
      </UBadge>
      <ClientOnly>
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
        <template #fallback>
          <USkeleton class="h-5 w-24" />
        </template>
      </ClientOnly>
      <UBadge color="white" size="xs"> tourney v{{ appVersion }} </UBadge>
    </div>
  </nav>
</template>

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
      <!--
      Rendered only on the client, because of time differing because of SSR.
      There is a workaround but here it's not worth it.
      https://github.com/danielroe/nuxt-time
      - Dino 27.09.2024
      -->
      <ClientOnly>
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
        <template #fallback>
          <USkeleton class="h-5 w-96" />
        </template>
      </ClientOnly>
    </div>
  </nav>
</template>

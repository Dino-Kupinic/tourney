<script setup lang="ts">
const appVersion = useAppVersion();

const isOnline = useOnline();
const { isSupported, memory } = useMemory();
const formatted = useDateFormat(useNow(), "dddd HH:mm:ss");

function size(v: number) {
  const kb = v / 1024 / 1024;
  return `${kb.toFixed(2)} MB`;
}
</script>

<template>
  <nav class="w-full flex justify-between items-center">
    <div class="items-center flex gap-1 p-1 pr-0 justify-end w-full">
      <UBadge
        v-if="isOnline"
        color="green"
        size="xs"
        variant="subtle"
        class="font-mono tracking-tight"
      >
        Online
      </UBadge>
      <UBadge
        v-else
        color="red"
        size="xs"
        variant="subtle"
        class="font-mono tracking-tight"
      >
        Offline
      </UBadge>
      <UBadge
        color="purple"
        size="xs"
        variant="subtle"
        class="font-mono tracking-tight"
      >
        {{ formatted }}
      </UBadge>
      <UBadge
        v-if="isSupported && memory"
        color="yellow"
        size="xs"
        variant="subtle"
        class="font-mono tracking-tight"
      >
        {{ size(memory.usedJSHeapSize) }}
      </UBadge>
      <UBadge
        v-else
        color="yellow"
        size="xs"
        variant="subtle"
        class="font-mono tracking-tight"
      >
        Kalkuliere...
      </UBadge>
      <UBadge color="white" size="xs" class="font-mono tracking-tight">
        Tourney v{{ appVersion }}
      </UBadge>
    </div>
  </nav>
</template>

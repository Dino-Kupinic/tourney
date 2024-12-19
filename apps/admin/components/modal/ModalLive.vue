<script setup lang="ts">
const isOpenLive = defineModel<boolean>()
defineEmits<{
  live: () => void
}>()
const is_live = useState<boolean>("is_live")
const liveButtonLabel = computed(() => {
  return is_live.value ? "Ja, Offline gehen" : "Ja, Live gehen"
})
const liveIcon = computed(() => {
  return is_live.value ? "i-heroicons-signal-slash" : "i-heroicons-signal"
})
</script>

<template>
  <UModal v-model="isOpenLive" :ui="{ width: 'w-full sm:max-w-md' }">
    <UCard
      :ui="{
        divide: 'divide-y divide-gray-100 dark:divide-gray-800',
        body: {
          padding: 'px-4 py-5 sm:p-6',
        },
        header: {
          padding: 'px-4 py-3 sm:px-6',
        },
        footer: {
          padding: 'px-4 py-3 sm:px-6',
        },
      }"
    >
      <template #header>
        <strong v-if="!is_live"> Live gehen? </strong>
        <strong v-else> Offline gehen? </strong>
      </template>

      <div
        v-if="!is_live"
        class="space-y-3 text-sm text-gray-500 dark:text-gray-400"
      >
        <p>
          Möchtest du das Turnier live gehen lassen? Es wird für alle sichtbar
          sein.
        </p>
        <p>
          <strong>Auswirkungen:</strong>
        </p>
        <div class="space-y-2 pl-6">
          <div class="flex items-center gap-3">
            <UIcon
              name="i-heroicons-check"
              class="text-primary-500"
              size="16"
            />
            <p>Das Turnier beginnt nach Zeitplan.</p>
          </div>
          <div class="flex items-center gap-3">
            <UIcon
              name="i-heroicons-check"
              class="text-primary-500"
              size="20"
            />
            <p>
              Gruppeneinteilung wird fixiert und kann nicht mehr geändert
              werden.
            </p>
          </div>
          <div class="flex items-center gap-3">
            <UIcon
              name="i-heroicons-check"
              class="text-primary-500"
              size="16"
            />
            <p>Manche Einstellungen sind nicht mehr änderbar.</p>
          </div>
        </div>
      </div>
      <div v-else>
        <p>Möchtest du das Turnier offline gehen lassen?</p>
      </div>

      <template #footer>
        <div class="flex items-center gap-2">
          <UButton
            variant="soft"
            size="xs"
            color="red"
            :icon="liveIcon"
            @click="$emit('live')"
            :label="liveButtonLabel"
          />
          <UButton
            color="gray"
            size="xs"
            @click="isOpenLive = false"
            label="Abbrechen"
          />
        </div>
      </template>
    </UCard>
  </UModal>
</template>

<script setup lang="ts">
import type { Enums, Tables } from "~/types/database.types"
import { z } from "zod"
import type { FormSubmitEvent } from "#ui/types"

const title = ref<string>("Anmeldung")
useHead({
  title: () => title.value,
})

const { columns } = useRegistrationTable()
const actions = [
  [
    {
      key: "in_progress",
      label: "Ausstehend",
      icon: "i-heroicons-arrow-path",
      click: () => onUpdate("Ausstehend"),
    },
  ],
  [
    {
      key: "submitted",
      label: "Abgesendet",
      icon: "i-heroicons-envelope",
      click: () => onUpdate("Abgesendet"),
    },
  ],
  [
    {
      key: "completed",
      label: "Abgeschlossen",
      icon: "i-heroicons-check",
      click: () => onUpdate("Abgeschlossen"),
    },
  ],
  [
    {
      key: "discarded",
      label: "Abgelehnt",
      icon: "i-heroicons-no-symbol",
      click: () => onUpdate("Abgelehnt"),
    },
  ],
]

const items = (row: Tables<"registration">) =>
  ref([
    [
      {
        label: "Editieren",
        icon: "i-heroicons-pencil-square-20-solid",
      },
      {
        label: "Info",
        icon: "i-heroicons-information-circle",
      },
      {
        label: "Löschen",
        icon: "i-heroicons-trash",
        click: () => onDelete(),
      },
    ],
  ])

const selectedColumns = ref(columns)
const columnsTable = computed(() =>
  columns.filter((column) => selectedColumns.value.includes(column)),
)

const selectedRows = ref<Tables<"registration">[]>([])
function select(row: Tables<"registration">) {
  const index = selectedRows.value.findIndex((item) => item.id === row.id)
  if (index === -1) {
    selectedRows.value.push(row)
  } else {
    selectedRows.value.splice(index, 1)
  }
}

const { data, status, refresh } = await useFetch("/api/registrations", {
  transform: (item) => {
    if (!item) return []
    return item.map((item) => ({
      id: item.id,
      name: item.name,
      class: item.class?.name,
      expire_date: item.expire_date,
      status: item.status,
    }))
  },
})

const search = ref<string>("")
const tableData = computed(() => data.value || [])
const filteredRows = computed(() => {
  if (!search.value) {
    return tableData.value
  }

  return tableData.value.filter((item) => {
    return Object.values(item).some((value) => {
      return String(value).toLowerCase().includes(search.value.toLowerCase())
    })
  })
})

const isOpenDelete = ref<boolean>(false)
const sort = ref({ column: "status", direction: "asc" as const })
const isOpenCreate = ref<boolean>(false)
const years = Array.from(
  { length: 10 },
  (_, i) =>
    `${new Date().getFullYear() + i}/${(new Date().getFullYear() + i + 1).toString().slice(2)}`,
)
const classYear = ref<string>(years[0])
const encodedYear = computed(() => encodeURIComponent(classYear.value))

const { data: classes } = await useFetch(`/api/classes/${encodedYear.value}`, {
  watch: [classYear],
})

const schema = z.object({
  expire_date: z.string().date(),
  teams: z.number().min(1, "Mindestens ein Team pro Klasse").default(1),
  year: z.string(),
})

type Schema = z.output<typeof schema>

const state = reactive({
  expire_date: undefined,
  teams: 1,
  year: classYear.value,
})

const onSubmitCreate = async (event: FormSubmitEvent<Schema>) => {
  // TODO: error handling
  schema.parse(state)
  await $fetch("/api/registrations/create", { method: "POST", body: state })
  isOpenCreate.value = false
  await refresh()
}

const registrationIds = computed(() => selectedRows.value.map((row) => row.id))
const onDelete = async () => {
  // TODO: error handling
  await $fetch("/api/registrations/delete", {
    method: "DELETE",
    body: registrationIds.value,
  })
  isOpenDelete.value = false
  selectedRows.value = []
  await refresh()
}

const onUpdate = async (status: Enums<"registration_status">) => {
  // TODO: error handling
  await $fetch("/api/registrations/update", {
    method: "PUT",
    body: { registrations: registrationIds.value, status: status },
  })
  selectedRows.value = []
  await refresh()
}
</script>

<template>
  <BasePageHeader :title="title">
    <!-- Filters -->
    <div class="ml-4 flex items-center gap-2">
      <!-- Delete Modal -->
      <UModal v-model="isOpenDelete" :ui="{ width: 'w-full sm:max-w-md' }">
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
            <strong> Anmeldungen löschen </strong>
          </template>

          <p>
            Möchten Sie wirklich
            <strong>{{ selectedRows.length }}</strong> Anmeldungen löschen?
          </p>

          <template #footer>
            <div class="flex items-center gap-2">
              <UButton
                variant="soft"
                size="xs"
                color="red"
                @click="onDelete"
                label="Löschen"
              />
              <UButton
                color="gray"
                size="xs"
                @click="isOpenDelete = false"
                label="Abbrechen"
              />
            </div>
          </template>
        </UCard>
      </UModal>

      <UButton
        v-if="selectedRows.length > 1"
        @click="isOpenDelete = true"
        icon="i-heroicons-trash"
        variant="soft"
        color="red"
        size="xs"
        label="Löschen..."
      />

      <UInput
        v-model="search"
        icon="i-heroicons-magnifying-glass-20-solid"
        placeholder="Suchen..."
        size="xs"
      />

      <UDropdown
        v-if="selectedRows.length > 1"
        :items="actions"
        :ui="{ width: 'w-40', item: { padding: 'p-1' } }"
      >
        <UButton
          icon="i-heroicons-chevron-down"
          trailing
          color="gray"
          size="xs"
          label="Markieren als"
        />
      </UDropdown>

      <USelectMenu
        v-model="selectedColumns"
        :options="columns"
        multiple
        v-slot="{ open }"
      >
        <UButton color="gray" size="xs" class="w-32 flex-1 justify-between">
          <div class="flex items-center gap-1">
            <UIcon name="i-heroicons-view-columns" class="h-4 w-4" />
            Spalten
          </div>
          <UIcon
            name="i-heroicons-chevron-right-20-solid"
            class="h-4 w-4 text-gray-400 transition-transform dark:text-gray-500"
            :class="[open && 'rotate-90 transform']"
          />
        </UButton>
      </USelectMenu>

      <UButton
        icon="i-heroicons-arrow-path"
        color="gray"
        size="xs"
        square
        @click="refresh"
      />

      <UButton
        size="xs"
        variant="soft"
        @click="isOpenCreate = true"
        label="Neue Anmeldung..."
      />

      <!-- Create Modal -->
      <UModal v-model="isOpenCreate" :ui="{ width: 'w-full sm:max-w-md' }">
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
            <strong> Neue Anmeldung </strong>
          </template>

          <UForm
            :schema="schema"
            :state="state"
            class="space-y-4"
            @submit="onSubmitCreate"
          >
            <UFormGroup
              label="Teams"
              name="teams"
              description="Anzahl an Anmeldungen für jede Klasse."
              required
            >
              <UInput v-model="state.teams" type="number" />
            </UFormGroup>

            <UFormGroup
              label="Klassen"
              name="classes"
              class="grow"
              description="Für diese Klassen wird ein Link generiert."
            >
              <ul
                class="h-40 w-full overflow-y-scroll rounded-md border border-gray-200 shadow-sm dark:border-gray-800"
              >
                <li
                  v-for="schoolClass in classes"
                  class="flex justify-between border-b border-gray-200 p-2 px-4 dark:border-gray-800"
                >
                  <p>{{ schoolClass.name }}</p>
                  <p>{{ schoolClass.year }}</p>
                </li>
              </ul>
            </UFormGroup>

            <UFormGroup label="Datensatz">
              <USelect v-model="classYear" :options="years" />
            </UFormGroup>

            <UFormGroup
              label="Ablaufdatum"
              name="date"
              description="An diesem Datum werden die Anmeldungen automatisch geschlossen."
              required
            >
              <UInput v-model="state.expire_date" type="date" />
            </UFormGroup>
          </UForm>

          <template #footer>
            <div class="flex items-center gap-2">
              <UButton
                variant="soft"
                size="xs"
                @click="onSubmitCreate"
                label="Erstellen"
              />
              <UButton
                color="gray"
                size="xs"
                @click="isOpenCreate = false"
                label="Abbrechen"
              />
            </div>
          </template>
        </UCard>
      </UModal>
    </div>
  </BasePageHeader>
  <BasePageContent>
    <!-- Table -->
    <UTable
      v-model="selectedRows"
      v-model:sort="sort"
      :rows="filteredRows"
      :columns="columnsTable"
      :loading="status === 'pending'"
      :loading-state="{
        icon: 'i-heroicons-arrow-path-20-solid',
        label: 'Lade...',
      }"
      class="h-full w-full bg-white dark:bg-gray-900"
      :ui="{
        wrapper: 'relative overflow-auto',
        th: {
          padding: 'px-4 py-3',
        },
        td: { base: 'max-w-[0] truncate', padding: 'py-2' },
      }"
      @select="select"
    >
      <template #status-data="{ row }">
        <UBadge
          size="xs"
          v-if="row.status === 'Ausstehend'"
          label="Ausstehend"
          color="yellow"
          variant="subtle"
        />
        <UBadge
          size="xs"
          v-else-if="row.status === 'Abgesendet'"
          label="Abgesendet"
          color="orange"
          variant="subtle"
        />
        <UBadge
          size="xs"
          v-else-if="row.status === 'Abgeschlossen'"
          label="Abgeschlossen"
          color="green"
          variant="subtle"
        />
        <UBadge
          size="xs"
          v-else
          label="Abgelehnt"
          color="red"
          variant="subtle"
        />
      </template>

      <template #date-data="{ row }">
        <span>{{ useDateFormat(row.expire_date, "DD.MM.YYYY") }}</span>
      </template>

      <template #actions-data="{ row }">
        <UDropdown :items="items(row).value" :ui="{ width: 'w-auto' }">
          <UButton
            color="gray"
            variant="ghost"
            icon="i-heroicons-ellipsis-horizontal-20-solid"
            size="2xs"
            square
          />
        </UDropdown>
      </template>

      <template #empty-state>
        <div class="mt-64 flex w-full items-center justify-center">
          <div class="max-w-96 space-y-3">
            <UIcon
              name="i-heroicons-ticket"
              size="24"
              class="text-gray-500 dark:text-gray-400"
            />
            <p class="text-base font-semibold tracking-tight">
              Keine Anmeldungen
            </p>
            <p class="text-sm text-gray-700 dark:text-gray-500">
              Mit Anmeldungen können sich Klassen bei Turnieren registrieren.
            </p>
          </div>
        </div>
      </template>
    </UTable>
  </BasePageContent>
</template>

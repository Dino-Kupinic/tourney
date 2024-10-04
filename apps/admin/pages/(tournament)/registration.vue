<script setup lang="ts">
import type { Database } from "~/types/database.types"

const title = ref<string>("Anmeldung")
useHead({
  title: () => title.value,
})

const columns = [
  {
    key: "tournament",
    label: "Turnier",
    sortable: true,
  },
  {
    key: "team",
    label: "Team",
    sortable: true,
  },
  {
    key: "expire_date",
    label: "Ablaufdatum",
    sortable: true,
  },
  {
    key: "status",
    label: "Status",
    sortable: true,
  },
  {
    key: "actions",
    label: "Aktionen",
    sortable: false,
  },
]

const selectedColumns = ref(columns)
const columnsTable = computed(() =>
  columns.filter((column) => selectedColumns.value.includes(column)),
)

// Selected Rows
const selectedRows = ref([])

function select(row) {
  const index = selectedRows.value.findIndex((item) => item.id === row.id)
  if (index === -1) {
    selectedRows.value.push(row)
  } else {
    selectedRows.value.splice(index, 1)
  }
}

// Actions
const actions = [
  [
    {
      key: "in_progress",
      label: "Ausstehend",
      icon: "i-heroicons-arrow-path",
    },
  ],
  [
    {
      key: "submitted",
      label: "Abgesendet",
      icon: "i-heroicons-envelope",
    },
  ],
  [
    {
      key: "completed",
      label: "Abgeschlossen",
      icon: "i-heroicons-check",
    },
  ],
  [
    {
      key: "discarded",
      label: "Abgelehnt",
      icon: "i-heroicons-no-symbol",
    },
  ],
]

// Filters
const todoStatus = [
  {
    key: "in_progress",
    label: "Ausstehend",
    value: "Ausstehend",
  },
  {
    key: "submitted",
    label: "Abgesendet",
    value: "Abgesendet",
  },
  {
    key: "completed",
    label: "Abgeschlossen",
    value: "Abgeschlossen",
  },
  {
    key: "declined",
    label: "Abgelehnt",
    value: "Abgelehnt",
  },
]

const client = useSupabaseClient<Database>()
const { data, status, error } = await useAsyncData("registration", async () => {
  const { data } = await client.from("registration").select("*")
  return data
})
console.log(data.value)
console.log(error.value)

const tableData = ref(
  data?.value?.map((item) => ({
    id: item.id,
    tournament: "aaa", // Add your value for tournament
    team: "bbb", // Add your value for team
    expire_date: item.expire_date,
    status: item.status,
  })) ?? [],
)

const search = ref("")
const selectedStatus = ref([])
const searchStatus = computed(() => {
  if (selectedStatus.value?.length === 0) {
    return ""
  }

  // if (selectedStatus?.value?.length > 1) {
  //   return `?completed=${selectedStatus.value[0].value}&completed=${selectedStatus.value[1].value}`
  // }
  //
  // return `?completed=${selectedStatus.value[0].value}`
})

const resetFilters = () => {
  search.value = ""
  selectedStatus.value = []
}

const items = (row) =>
  ref([
    [
      {
        label: "Edit",
        icon: "i-heroicons-pencil-square-20-solid",
      },
      {
        label: "Info",
        icon: "i-heroicons-information-circle",
      },
    ],
  ])

// Pagination
const sort = ref({ column: "id", direction: "asc" as const })
// Data
// const { data: todos, status } = await useLazyAsyncData<
//   {
//     id: number
//     title: string
//     completed: string
//   }[]
// >(
//   "todos",
//   () =>
//     ($fetch as any)(
//       `https://jsonplaceholder.typicode.com/todos${searchStatus.value}`,
//       {
//         query: {
//           q: search.value,
//           _sort: sort.value.column,
//           _order: sort.value.direction,
//         },
//       },
//     ),
//   {
//     default: () => [],
//     watch: [search, searchStatus, sort],
//   },
// )
</script>

<template>
  <BasePageHeader :title="title">
    <!-- Filters -->
    <div class="ml-4 flex items-center gap-2">
      <UInput
        v-model="search"
        icon="i-heroicons-magnifying-glass-20-solid"
        placeholder="Suchen..."
        size="xs"
      />

      <USelectMenu
        v-model="selectedStatus"
        :options="todoStatus"
        multiple
        size="xs"
        placeholder="Status"
        class="w-32"
      />

      <UButton
        icon="i-heroicons-funnel"
        color="gray"
        size="xs"
        :disabled="search === '' && selectedStatus.length === 0"
        @click="resetFilters"
        square
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
        >
          Markieren als
        </UButton>
      </UDropdown>
      <USelectMenu
        v-model="selectedColumns"
        :options="columns"
        multiple
        v-slot="{ open }"
      >
        <UButton color="gray" size="xs" class="w-36 flex-1 justify-between">
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

      <UButton size="xs" variant="soft"> Neue Anmeldung... </UButton>
    </div>
  </BasePageHeader>
  <BasePageContent>
    <UTable
      v-model="selectedRows"
      v-model:sort="sort"
      :rows="tableData"
      :columns="columnsTable"
      :loading="status === 'pending'"
      sort-asc-icon="i-heroicons-arrow-up"
      sort-desc-icon="i-heroicons-arrow-down"
      sort-mode="manual"
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
    </UTable>
  </BasePageContent>
</template>

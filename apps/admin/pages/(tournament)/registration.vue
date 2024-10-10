<script setup lang="ts">
import type { Database, Tables } from "~/types/database.types"
import type { QueryData } from "@supabase/supabase-js"
import { number, z } from "zod"

const title = ref<string>("Anmeldung")
useHead({
  title: () => title.value,
})

const { actions, todoStatus, columns, items } = useRegistrationTable()

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

const client = useSupabaseClient<Database>()
const registrationViewQuery = client
  .from("registration")
  .select("*, class(id, name)")

type registrationView = QueryData<typeof registrationViewQuery>

const { data, status, error, refresh } = await useAsyncData(
  "registration",
  async () => {
    const { data } = await registrationViewQuery.returns<registrationView>()
    return data
  },
)
console.log(data)

const tableData = ref(
  data?.value?.map((item) => ({
    id: item.id,
    class: item.class?.name,
    date: item.expire_date,
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

const isOpen = ref<boolean>(false)

const years = Array.from({ length: 20 }, (_, i) => new Date().getFullYear() + i)
const classYear = ref<number>(years[0])

const { data: classes } = await useAsyncData(
  "classes",
  async () => {
    const { data } = await client
      .from("class")
      .select("name, year")
      .eq("year", classYear.value)
      .order("name", { ascending: false })
    return data
  },
  { watch: [classYear] },
)
console.log(classes.value)

const schema = z.object({
  email: z.string().email("Invalid email"),
  password: z.string(),
})

type Schema = z.output<typeof schema>

const state = reactive({
  email: undefined,
  password: undefined,
})
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

      <UButton
        icon="i-heroicons-funnel"
        color="gray"
        size="xs"
        :disabled="search === '' && selectedStatus.length === 0"
        @click="resetFilters"
        square
      />

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
        @click="isOpen = true"
        label="Neue Anmeldung..."
      />
      <UModal v-model="isOpen">
        <UCard
          :ui="{
            ring: '',
            divide: 'divide-y divide-gray-100 dark:divide-gray-800',
            body: {
              padding: 'p-5',
            },
            header: {
              padding: 'p-3',
            },
            footer: {
              padding: 'p-3',
            },
          }"
        >
          <template #header> Neue Anmeldung </template>

          <UForm :schema="schema" :state="state" class="space-y-4">
            <UFormGroup
              label="Klassen"
              name="classes"
              class="grow"
              description="Für diese Klassen wird ein Link generiert."
            >
              <ul
                class="h-40 w-full overflow-y-auto rounded-md border border-gray-800"
              >
                <li
                  v-for="schoolClass in classes"
                  class="flex justify-between border-b border-gray-800 p-2 px-4"
                >
                  <p>{{ schoolClass.name }}</p>
                  <p>{{ schoolClass.year }}</p>
                </li>
              </ul>
            </UFormGroup>

            <UFormGroup label="E-mail" name="email">
              <UInput v-model="state.email" />
            </UFormGroup>

            <UFormGroup label="Jahr" name="year">
              <UInput v-model="state.email" />
            </UFormGroup>

            <UFormGroup label="Passwort" name="password">
              <UInput v-model="state.password" type="password" />
            </UFormGroup>
          </UForm>

          <template #footer>
            <div class="flex items-center gap-2">
              <UButton variant="soft" size="xs">Erstellen</UButton>
              <UButton
                variant="soft"
                color="red"
                size="xs"
                @click="isOpen = false"
                >Abbrechen</UButton
              >
            </div>
          </template>
        </UCard>
      </UModal>
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
    </UTable>
  </BasePageContent>
</template>

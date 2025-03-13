<script setup lang="ts">
import type { Tables } from "~/types/database.types"
import { z } from "zod"

const title = ref<string>("Klassenverwaltung")
useHead({
  title: () => title.value,
})

// State for managing classes
const { data, refresh, status } = await useFetch("/api/classes", {
  transform: (item) => {
    if (!item) return []
    return item.map((item) => ({
      id: item.id,
      name: item.name,
      year: item.year,
    }))
  },
})

// Selected rows for batch operations
const selectedRows = ref<Tables<"class">[]>([])
function select(row: Tables<"class">) {
  const index = selectedRows.value.findIndex((item) => item.id === row.id)
  if (index === -1) {
    selectedRows.value.push(row)
  } else {
    selectedRows.value.splice(index, 1)
  }
}

// Search functionality
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

// Modal states
const isOpenDelete = ref<boolean>(false)
const isOpenEdit = ref<boolean>(false)
const isOpenCreate = ref<boolean>(false)
const isOpenMultipleCreate = ref<boolean>(false)

// Year selection
const years = Array.from(
  { length: 11 },
  (_, i) =>
    `${new Date().getFullYear() + i - 1}/${(new Date().getFullYear() + i).toString().slice(2)}`,
)
const selectedYear = ref<string>(years[0])
const encodedYear = computed(() => encodeURIComponent(selectedYear.value))

// Fetch classes for selected year
const { data: yearClasses, refresh: refreshYearClasses } = await useFetch(
  () => `/api/classes/${encodedYear.value}`,
  {
    watch: [selectedYear],
  },
)

// Schema for creating a single class
const creationSchemaSingle = z.object({
  name: z.string().min(1, "Klassenname ist erforderlich"),
  year: z.string(),
})

const creationStateSingle = reactive({
  name: "",
  year: selectedYear.value,
})

// Schema for creating multiple classes
const creationSchemaMultiple = z.object({
  prefix: z.string().min(1, "Präfix ist erforderlich"),
  count: z
    .number()
    .min(1, "Mindestens eine Klasse")
    .max(20, "Maximal 20 Klassen"),
  year: z.string(),
})

const creationStateMultiple = reactive({
  prefix: "",
  count: 1,
  year: selectedYear.value,
})

// Schema for editing a class
const editSchema = z.object({
  id: z.string(),
  name: z.string().min(1, "Klassenname ist erforderlich"),
  year: z.string(),
})

const editState = reactive({
  id: "",
  name: "",
  year: "",
})

// Create a single class
const onSubmitCreateSingle = async () => {
  try {
    creationSchemaSingle.parse(creationStateSingle)
    await $fetch("/api/classes/create/single", {
      method: "POST",
      body: creationStateSingle,
    })
    isOpenCreate.value = false
    await refresh()
    await refreshYearClasses()
    displaySuccessNotification(
      "Klasse erstellt",
      "Die Klasse wurde erfolgreich erstellt.",
    )
  } catch (err) {
    console.error(err)
    displayFailureNotification(
      "Fehler beim Erstellen",
      "Die Klasse konnte nicht erstellt werden.",
    )
  }
}

// Create multiple classes
const onSubmitCreateMultiple = async () => {
  try {
    creationSchemaMultiple.parse(creationStateMultiple)
    await $fetch("/api/classes/create/multiple", {
      method: "POST",
      body: creationStateMultiple,
    })
    isOpenMultipleCreate.value = false
    await refresh()
    await refreshYearClasses()
    displaySuccessNotification(
      "Klassen erstellt",
      "Die Klassen wurden erfolgreich erstellt.",
    )
  } catch (err) {
    console.error(err)
    displayFailureNotification(
      "Fehler beim Erstellen",
      "Die Klassen konnten nicht erstellt werden.",
    )
  }
}

// Edit a class
const onEdit = async (row: Tables<"class">) => {
  isOpenEdit.value = true
  editState.id = row.id
  editState.name = row.name
  editState.year = row.year
}

const onSubmitEdit = async () => {
  try {
    editSchema.parse(editState)
    await $fetch("/api/classes/update", {
      method: "PUT",
      body: editState,
    })
    isOpenEdit.value = false
    await refresh()
    await refreshYearClasses()
    displaySuccessNotification(
      "Klasse aktualisiert",
      "Die Klasse wurde erfolgreich aktualisiert.",
    )
  } catch (err) {
    console.error(err)
    displayFailureNotification(
      "Fehler beim Aktualisieren",
      "Die Klasse konnte nicht aktualisiert werden.",
    )
  }
}

// Delete selected classes
const classIds = computed(() => selectedRows.value.map((row) => row.id))
const onDelete = async () => {
  try {
    await $fetch("/api/classes/delete", {
      method: "DELETE",
      body: classIds.value,
    })
    isOpenDelete.value = false
    selectedRows.value = []
    await refresh()
    await refreshYearClasses()
    displaySuccessNotification(
      "Klassen gelöscht",
      "Die Klassen wurden erfolgreich gelöscht.",
    )
  } catch (err) {
    console.error(err)
    displayFailureNotification(
      "Fehler beim Löschen",
      "Die Klassen konnten nicht gelöscht werden.",
    )
  }
}
</script>

<template>
  <BasePageHeader :title="title">
    <ToolbarContainer>
      <SearchInput v-model="search" placeholder="Klasse suchen..." />
      <USelect
        v-model="selectedYear"
        :options="years"
        placeholder="Schuljahr auswählen"
        size="xs"
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
        @click="isOpenCreate = true"
        label="Neue Klasse..."
      />
      <UButton
        size="xs"
        variant="soft"
        @click="isOpenMultipleCreate = true"
        label="Mehrere Klassen..."
      />
      <UButton
        v-if="selectedRows.length > 0"
        size="xs"
        color="red"
        variant="soft"
        @click="isOpenDelete = true"
        label="Löschen"
      />
      <!-- Create Single Class Modal -->
      <ModalCreate
        title="Neue Klasse"
        v-model="isOpenCreate"
        @create="onSubmitCreateSingle"
      >
        <div class="space-y-4">
          <UFormGroup label="Schuljahr">
            <USelect
              v-model="creationStateSingle.year"
              :options="years"
              placeholder="Schuljahr auswählen"
            />
          </UFormGroup>
          <UFormGroup label="Klassenname">
            <UInput v-model="creationStateSingle.name" placeholder="z.B. 10a" />
          </UFormGroup>
        </div>
      </ModalCreate>

      <!-- Create Multiple Classes Modal -->
      <ModalCreate
        title="Mehrere Klassen erstellen"
        v-model="isOpenMultipleCreate"
        @create="onSubmitCreateMultiple"
      >
        <div class="space-y-4">
          <UFormGroup label="Schuljahr">
            <USelect
              v-model="creationStateMultiple.year"
              :options="years"
              placeholder="Schuljahr auswählen"
            />
          </UFormGroup>
          <UFormGroup label="Präfix">
            <UInput
              v-model="creationStateMultiple.prefix"
              placeholder="z.B. 10"
            />
          </UFormGroup>
          <UFormGroup label="Anzahl">
            <UInput
              v-model.number="creationStateMultiple.count"
              type="number"
              min="1"
              max="20"
            />
          </UFormGroup>
          <UAlert
            v-if="
              creationStateMultiple.prefix && creationStateMultiple.count > 0
            "
            icon="i-heroicons-information-circle"
            color="primary"
            variant="soft"
            title="Vorschau"
          >
            <p>Es werden folgende Klassen erstellt:</p>
            <ul class="list-disc pl-5">
              <li
                v-for="i in Math.min(creationStateMultiple.count, 20)"
                :key="i"
              >
                {{ creationStateMultiple.prefix
                }}{{ String.fromCharCode(96 + i) }}
              </li>
            </ul>
          </UAlert>
        </div>
      </ModalCreate>

      <!-- Edit Class Modal -->
      <ModalCreate
        title="Klasse bearbeiten"
        v-model="isOpenEdit"
        @create="onSubmitEdit"
      >
        <div class="space-y-4">
          <UFormGroup label="Schuljahr">
            <USelect
              v-model="editState.year"
              :options="years"
              placeholder="Schuljahr auswählen"
            />
          </UFormGroup>
          <UFormGroup label="Klassenname">
            <UInput v-model="editState.name" placeholder="z.B. 10a" />
          </UFormGroup>
        </div>
      </ModalCreate>

      <!-- Delete Classes Modal -->
      <ModalDelete v-model="isOpenDelete" @delete="onDelete">
        <div class="space-y-4">
          <p>
            Sind Sie sicher, dass Sie
            <strong>{{ selectedRows.length }}</strong> Klasse(n) löschen
            möchten?
          </p>
          <UAlert
            icon="i-heroicons-exclamation-triangle"
            color="red"
            variant="soft"
            title="Achtung"
            description="Diese Aktion kann nicht rückgängig gemacht werden. Alle Verknüpfungen zu dieser Klasse werden ebenfalls gelöscht."
          />
        </div>
      </ModalDelete>
    </ToolbarContainer>
  </BasePageHeader>
  <BasePageContent>
    <div class="h-full overflow-auto">
      <template v-if="yearClasses && yearClasses.length > 0">
        <UTable
          :rows="filteredRows"
          :columns="[
            {
              key: 'select',
              label: '',
              sortable: false,
            },
            {
              key: 'name',
              label: 'Klasse',
              sortable: true,
            },
            {
              key: 'year',
              label: 'Schuljahr',
            },
            {
              key: 'actions',
              label: 'Aktionen',
              sortable: false,
            },
          ]"
          :sort="{ column: 'name', direction: 'asc' }"
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
          <template #select-data="{ row }">
            <UCheckbox
              :model-value="selectedRows.some((item) => item.id === row.id)"
              @change="select(row)"
            />
          </template>
          <template #actions-data="{ row }">
            <div class="flex items-center gap-2">
              <UButton
                color="primary"
                variant="ghost"
                icon="i-heroicons-pencil-square"
                size="xs"
                @click="onEdit(row)"
              />
            </div>
          </template>
        </UTable>
      </template>
      <template v-else>
        <UAlert
          icon="i-heroicons-information-circle"
          color="primary"
          variant="soft"
          title="Keine Klassen gefunden"
          description="Für das ausgewählte Schuljahr wurden keine Klassen gefunden. Erstellen Sie neue Klassen mit dem Button 'Neue Klasse...' oder 'Mehrere Klassen...'."
        />
      </template>
    </div>
  </BasePageContent>
</template>

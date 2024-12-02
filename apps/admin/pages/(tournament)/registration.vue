<script setup lang="ts">
import type { Enums } from "~/types/database.types"
import type { Link, LinkGroup } from "~/types/link"
import { z } from "zod"

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

const items = (row: RegistrationColumn) =>
  ref([
    [
      {
        label: "Link kopieren",
        icon: "i-heroicons-clipboard-document-check",
        click: () => onCopyLink(row),
      },
      {
        label: "Editieren",
        icon: "i-heroicons-pencil-square-20-solid",
        click: () => onEdit(row),
      },
      {
        label: "Info",
        icon: "i-heroicons-information-circle",
        click: () => onInfo(row),
      },
    ],
    [
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

const tabItems = [
  {
    slot: "multiple",
    key: "multiple",
    label: "Mehrfach",
    icon: "i-heroicons-rectangle-stack",
    description: "Anmeldungen für alle Klassen erstellen.",
  },
  {
    slot: "single",
    key: "single",
    label: "Einzel",
    icon: "i-heroicons-document",
    description: "Anmeldung für eine Klasse erstellen.",
  },
]

type RegistrationColumn = {
  id: string
  name: string
  class: string
  expire_date: string
  status: Enums<"registration_status">
  allow_class_mixing: boolean
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
      allow_class_mixing: item.allow_class_mixing,
    }))
  },
})

const selectedRows = ref<RegistrationColumn[]>([])
function select(row: RegistrationColumn) {
  const index = selectedRows.value.findIndex((item) => item.id === row.id)
  if (index === -1) {
    selectedRows.value.push(row)
  } else {
    selectedRows.value.splice(index, 1)
  }
}

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

const sort = ref({ column: "status", direction: "asc" as const })
const isOpenDelete = ref<boolean>(false)
const isOpenEdit = ref<boolean>(false)
const isOpenCreate = ref<boolean>(false)
const isOpenInfo = ref<boolean>(false)
const isOpenLinks = ref<boolean>(false)
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

const creationSchemaMultiple = z.object({
  expire_date: z.string().date(),
  teams: z.number().min(1, "Mindestens ein Team pro Klasse").default(1),
  year: z.string(),
})

const creationStateMultiple = reactive({
  expire_date: undefined,
  teams: 1,
  year: classYear.value,
})

const onSubmitCreateMultiple = async () => {
  try {
    creationSchemaMultiple.parse(creationStateMultiple)
    await $fetch("/api/registrations/create", {
      method: "POST",
      body: creationStateMultiple,
    })
    isOpenCreate.value = false
    await refresh()
    displaySuccessNotification(
      "Anmeldungen erstellt",
      "Die Anmeldungen wurden erfolgreich erstellt.",
    )
  } catch (err) {
    console.error(err)
    displayFailureNotification(
      "Fehler beim Erstellen",
      "Die Anmeldungen konnte nicht erstellt werden.",
    )
  }
}

const creationSchemaSingle = z.object({
  expire_date: z.string().date(),
  teams: z.number().min(1, "Mindestens ein Team pro Klasse").default(1),
  year: z.string(),
})

const creationStateSingle = reactive({
  expire_date: undefined,
  teams: 1,
  year: classYear.value,
})

const onSubmitCreateSingle = async () => {
  try {
    creationSchemaMultiple.parse(creationStateMultiple)
    await $fetch("/api/registrations/create", {
      method: "POST",
      body: creationStateMultiple,
    })
    isOpenCreate.value = false
    await refresh()
    displaySuccessNotification(
      "Anmeldungen erstellt",
      "Die Anmeldungen wurden erfolgreich erstellt.",
    )
  } catch (err) {
    console.error(err)
    displayFailureNotification(
      "Fehler beim Erstellen",
      "Die Anmeldungen konnte nicht erstellt werden.",
    )
  }
}

const registrationIds = computed(() => selectedRows.value.map((row) => row.id))
const onDelete = async () => {
  try {
    await $fetch("/api/registrations/delete", {
      method: "DELETE",
      body: registrationIds.value,
    })
    isOpenDelete.value = false
    selectedRows.value = []
    await refresh()
    displaySuccessNotification(
      "Anmeldungen gelöscht",
      "Die Anmeldungen wurden erfolgreich gelöscht.",
    )
  } catch (err) {
    console.error(err)
    displayFailureNotification(
      "Fehler beim Löschen",
      "Die Anmeldungen konnten nicht gelöscht werden.",
    )
  }
}

const onUpdate = async (status: Enums<"registration_status">) => {
  try {
    await $fetch("/api/registrations/update", {
      method: "PUT",
      body: { registrations: registrationIds.value, status: status },
    })
    selectedRows.value = []
    await refresh()
    displaySuccessNotification(
      "Anmeldungen aktualisiert",
      "Die Anmeldungen wurden erfolgreich aktualisiert.",
    )
  } catch (err) {
    console.error(err)
    displayFailureNotification(
      "Fehler beim Aktualisieren",
      "Die Anmeldungen konnten nicht aktualisiert werden.",
    )
  }
}

const config = useRuntimeConfig()
const onCopyLink = async (row: RegistrationColumn) => {
  const source: string = `${config.public.clientUrl}/registrations/${row.id}`
  const { text, copy, copied } = useClipboard({ source })
  await copy()
  copied.value
    ? displaySuccessNotification("Link kopiert", text.value)
    : displayFailureNotification("Fehler beim Kopieren", text.value)
}

const editSchema = z.object({
  id: z.string(),
  expire_date: z.string().date(),
  name: z.string(),
  status: z.custom<Enums<"registration_status">>(),
  allow_class_mixing: z.boolean(),
  class: z.string(),
})

const editState = reactive({
  id: "",
  expire_date: "",
  name: "",
  status: "",
  allow_class_mixing: false,
  class: "",
})
const statusOptions: Enums<"registration_status">[] = [
  "Ausstehend",
  "Abgesendet",
  "Abgeschlossen",
  "Abgelehnt",
]

const onEdit = async (row: RegistrationColumn) => {
  isOpenEdit.value = true

  editState.id = row.id
  editState.expire_date = row.expire_date
  editState.name = row.name
  editState.status = row.status
  editState.allow_class_mixing = row.allow_class_mixing
  editState.class = row.class
}

const infoDisplay = ref<RegistrationColumn>()
const onInfo = async (row: RegistrationColumn) => {
  isOpenInfo.value = true
  infoDisplay.value = row
}

const onSubmitEdit = async () => {
  try {
    editSchema.parse(editState)
    await $fetch("/api/registrations/edit", {
      method: "PUT",
      body: editState,
    })
    isOpenEdit.value = false
    await refresh()
    displaySuccessNotification(
      "Editiert",
      "Die Anmeldung wurde erfolgreich editiert.",
    )
  } catch (err) {
    console.error(err)
    displayFailureNotification(
      "Fehler beim Editieren",
      "Die Anmeldung konnte nicht editiert werden.",
    )
  }
}

const links = ref<LinkGroup>({})
const groupLinks = () => {
  return selectedRows.value.reduce(
    (acc, row) => {
      const { class: className, name, id } = row
      if (!acc[className]) {
        acc[className] = []
      }
      const url: string = `${config.public.clientUrl}/registrations/${id}`
      acc[className].push({ name, url, class: className })
      return acc
    },
    {} as Record<string, Link[]>,
  )
}

const generateLinks = () => {
  links.value = groupLinks()
  isOpenLinks.value = true
}

const refreshTable = () => {
  refresh()
  displaySuccessNotification("Aktualisiert", "Die Tabelle wurde aktualisiert.")
}

function onChange(index: number) {
  const item = tabItems[index]

  alert(`${item.label} was clicked!`)
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

      <UInput
        v-model="search"
        icon="i-heroicons-magnifying-glass-20-solid"
        placeholder="Suchen..."
        size="xs"
      />

      <template v-if="selectedRows.length > 1">
        <UButton
          @click="isOpenDelete = true"
          icon="i-heroicons-trash"
          variant="soft"
          color="red"
          size="xs"
          label="Löschen..."
        />
        <UButton
          label="Links exportieren"
          icon="i-heroicons-arrow-up-on-square"
          @click="generateLinks"
          color="gray"
          size="xs"
        />
      </template>

      <UDropdown
        v-if="selectedRows.length > 0"
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
        @click="refreshTable"
      />

      <UButton
        size="xs"
        variant="soft"
        @click="isOpenCreate = true"
        label="Neue Anmeldung..."
      />

      <!-- Link Modal -->
      <UModal
        v-model="isOpenLinks"
        :ui="{ width: 'w-full sm:max-w-2xl' }"
        prevent-close
      >
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
            <strong> Links </strong>
          </template>

          <ul
            class="h-96 w-full overflow-y-scroll rounded-md border border-gray-200 shadow-sm dark:border-gray-800"
          >
            <li
              v-for="[className, classLinks] in Object.entries(links)"
              :key="className"
              class="flex justify-between border-b border-gray-200 p-2 px-4 dark:border-gray-800"
            >
              <div class="my-3 flex flex-col gap-3">
                <strong>{{ className }}</strong>
                <ul class="space-y-1">
                  <li v-for="link in classLinks" :key="link.url">
                    <p class="text-xs">{{ link.name }}</p>
                    <code class="text-xs">{{ link.url }}</code>
                  </li>
                </ul>
                <div>
                  <UButton variant="soft" size="xs" label="Kopieren" />
                </div>
              </div>
            </li>
          </ul>

          <template #footer>
            <UButton
              color="gray"
              size="xs"
              @click="isOpenLinks = false"
              label="Fertig"
            />
          </template>
        </UCard>
      </UModal>

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

          <UTabs
            :items="tabItems"
            class="w-full"
            @change="onChange"
            :ui="{ list: { tab: { height: 'h-7' }, height: 'h-9' } }"
          >
            <template #icon="{ item, selected }">
              <UIcon
                :name="item.icon"
                class="me-2 h-4 w-4 flex-shrink-0"
                :class="[selected && 'text-primary-500 dark:text-primary-400']"
              />
            </template>

            <template #multiple="{ item }">
              <UForm
                :schema="creationSchemaMultiple"
                :state="creationStateMultiple"
                class="space-y-4 pt-2"
                @submit="onSubmitCreateMultiple"
              >
                <UFormGroup
                  label="Teams"
                  name="teams"
                  description="Anzahl an Anmeldungen für jede Klasse."
                  required
                >
                  <UInput v-model="creationStateMultiple.teams" type="number" />
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
                      :key="schoolClass.name"
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
                  <UInput
                    v-model="creationStateMultiple.expire_date"
                    type="date"
                  />
                </UFormGroup>
              </UForm>
            </template>
            <template #single="{ item }">
              <UForm
                :schema="creationSchemaSingle"
                :state="creationSchemaSingle"
                class="space-y-4 pt-2"
                @submit="onSubmitCreateSingle"
              >
              </UForm>
            </template>
          </UTabs>

          <template #footer>
            <div class="flex items-center gap-2">
              <!-- TODO -->
              <UButton
                variant="soft"
                size="xs"
                @click="onSubmitCreateMultiple"
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

      <!-- Edit Modal -->
      <UModal v-model="isOpenEdit" :ui="{ width: 'w-full sm:max-w-md' }">
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
            <strong> Editieren </strong>
          </template>

          <UForm
            :schema="editSchema"
            :state="editState"
            class="space-y-4"
            @submit="onSubmitEdit"
          >
            <UFormGroup
              label="Ablaufdatum"
              name="date"
              description="An diesem Datum wird die Anmeldung automatisch geschlossen."
            >
              <UInput v-model="editState.expire_date" type="date" />
            </UFormGroup>

            <UFormGroup
              label="Status"
              name="status"
              description="Der Status der Anmeldung."
            >
              <USelect v-model="editState.status" :options="statusOptions" />
            </UFormGroup>

            <UFormGroup
              label="Klassenmischung erlauben"
              name="allow_class_mixing"
              description="Schüler können sich in anderen Klassen anmelden."
              :ui="{
                wrapper:
                  'flex items-center justify-between rounded-md bg-gray-50 p-3 dark:bg-gray-800 gap-3',
              }"
            >
              <UToggle v-model="editState.allow_class_mixing" />
            </UFormGroup>
          </UForm>

          <template #footer>
            <div class="flex items-center gap-2">
              <UButton
                variant="soft"
                size="xs"
                @click="onSubmitEdit"
                label="Speichern"
              />
              <UButton
                color="gray"
                size="xs"
                @click="isOpenEdit = false"
                label="Abbrechen"
              />
            </div>
          </template>
        </UCard>
      </UModal>

      <!-- Info Modal -->
      <UModal v-model="isOpenInfo" :ui="{ width: 'w-full sm:max-w-md' }">
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
            <strong> Info </strong>
          </template>

          <pre>{{ infoDisplay }}</pre>

          <template #footer>
            <div class="flex items-center gap-2">
              <UButton
                color="gray"
                size="xs"
                @click="isOpenInfo = false"
                label="Fertig"
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

      <template #allow_class_mixing-data="{ row }">
        <div>
          <span v-if="row.allow_class_mixing" class="flex items-center gap-2">
            <UIcon class="text-green-500" name="i-heroicons-check" size="20" />
            Ja
          </span>
          <span v-else class="flex items-center gap-2">
            <UIcon class="text-red-500" name="i-heroicons-x-mark" size="20" />
            Nein
          </span>
        </div>
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

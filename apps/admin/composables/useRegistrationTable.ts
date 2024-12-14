import type { TableColumn } from "#ui/types"
import type { RegistrationColumn } from "~/types/registration"
import type { Enums } from "~/types/database.types"

export const useRegistrationTable = (
  onUpdate: (status: Enums<"registration_status">) => void,
  onCopyLink: (row: RegistrationColumn) => void,
  onEdit: (row: RegistrationColumn) => void,
  onInfo: (row: RegistrationColumn) => void,
  onDelete: () => void,
) => {
  const columns: TableColumn[] = [
    {
      key: "name",
      label: "Name",
      sortable: true,
    },
    {
      key: "class",
      label: "Klasse",
      sortable: true,
    },
    {
      key: "date",
      label: "Ablaufdatum",
      sortable: true,
    },
    {
      key: "status",
      label: "Status",
      sortable: true,
    },
    {
      key: "allow_class_mixing",
      label: "Mischung",
      sortable: true,
    },
    {
      key: "actions",
      label: "Aktionen",
    },
  ]

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

  return {
    columns,
    items,
    actions,
    tabItems,
  }
}

import type { Tables } from "~/types/database.types"

export const useRegistrationTable = () => {
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

  const columns = [
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
      sortable: false,
    },
    {
      key: "status",
      label: "Status",
      sortable: true,
    },
    {
      key: "actions",
      label: "Aktionen",
    },
  ]

  const items = (row: Tables<"registration">) =>
    ref([
      [
        {
          label: "Editieren",
          icon: "i-heroicons-pencil-square-20-solid",
        },
        {
          label: "Löschen...",
          icon: "i-heroicons-trash",
        },
        {
          label: "Info",
          icon: "i-heroicons-information-circle",
        },
      ],
    ])

  return {
    actions,
    columns,
    items,
  }
}

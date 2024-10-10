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

  const columns = [
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
      key: "actions",
      label: "Aktionen",
      sortable: false,
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
          label: "Info",
          icon: "i-heroicons-information-circle",
        },
      ],
    ])

  return {
    actions,
    todoStatus,
    columns,
    items,
  }
}

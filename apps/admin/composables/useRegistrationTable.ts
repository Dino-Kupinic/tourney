import type { Tables } from "~/types/database.types"

export const useRegistrationTable = () => {
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

  return {
    columns,
  }
}

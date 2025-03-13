import type { TableColumn } from "#ui/types"

export type ClassColumn = {
  id: string
  name: string
  year: string
}

export const useClassTable = (
  onEdit: (row: ClassColumn) => void,
  onInfo: (row: ClassColumn) => void,
  onDelete: () => void,
) => {
  const columns: TableColumn[] = [
    {
      key: "name",
      label: "Klasse",
      sortable: true,
    },
    {
      key: "year",
      label: "Schuljahr",
    },
    {
      key: "actions",
      label: "Aktionen",
    },
  ]

  const items = (row: ClassColumn) =>
    ref([
      [
        {
          label: "Info",
          icon: "i-heroicons-information-circle",
          click: () => onInfo(row),
        },
        {
          label: "Editieren",
          icon: "i-heroicons-pencil-square-20-solid",
          click: () => onEdit(row as ClassColumn),
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

  return {
    columns,
    items,
  }
}

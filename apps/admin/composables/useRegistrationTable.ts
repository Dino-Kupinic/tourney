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
      key: "tournament",
      label: "Turnier",
      sortable: true,
    },
    {
      key: "class",
      label: "Klasse",
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

  return {
    actions,
    todoStatus,
    columns,
  }
}

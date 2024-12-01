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
      key: "allow_class_mixing",
      label: "Mischung",
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

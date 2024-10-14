import type { HorizontalNavigationLink } from "#ui/types"

export default function (mobileOrder: boolean = false) {
  if (mobileOrder) {
    return [
      {
        label: "Turniere",
        icon: "i-heroicons-trophy",
        to: "/tournaments",
      },
      {
        label: "Live",
        icon: "i-heroicons-signal",
        to: "/live",
      },
      {
        label: "Medien",
        icon: "i-heroicons-newspaper",
        to: "/media",
      },
    ] as HorizontalNavigationLink[]
  }

  return [
    {
      label: "Live",
      icon: "i-heroicons-signal",
      to: "/live",
    },
    {
      label: "Turniere",
      icon: "i-heroicons-trophy",
      to: "/tournaments",
    },
    {
      label: "Medien",
      icon: "i-heroicons-newspaper",
      to: "/media",
    },
  ] as HorizontalNavigationLink[]
}

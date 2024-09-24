import type { HorizontalNavigationLink } from "#ui/types"

export default function (mobileOrder: boolean = false) {
  if (mobileOrder) {
    return [
      {
        label: "Medien",
        icon: "i-lucide-newspaper",
        to: "/news",
      },
      {
        label: "Live",
        icon: "i-lucide-radio",
        to: "/live",
      },
      {
        label: "Turniere",
        icon: "i-lucide-trophy",
        to: "/tournaments",
      },
      {
        label: "Einstellungen",
        icon: "i-lucide-settings",
        to: "/settings",
      },
    ] as HorizontalNavigationLink[]
  }

  return [
    {
      label: "Live",
      icon: "i-lucide-radio",
      to: "/live",
    },
    {
      label: "Turniere",
      icon: "i-lucide-trophy",
      to: "/tournaments",
    },
    {
      label: "Medien",
      icon: "i-lucide-newspaper",
      to: "/news",
    },
    {
      label: "Einstellungen",
      icon: "i-lucide-settings",
      to: "/settings",
    },
  ] as HorizontalNavigationLink[]
}

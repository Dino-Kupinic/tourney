import type { Database } from "~/types/database.types"

export type Match = Database["public"]["Views"]["matches_status"]["Row"] & {
  status: "completed" | "live" | "upcoming"

  team1:
    | (Database["public"]["Tables"]["team"]["Row"] & {
        group: Database["public"]["Tables"]["group"]["Row"] | null
        logo: Database["public"]["Tables"]["logo"]["Row"] | null
        logo_variant: Database["public"]["Tables"]["logo_variant"]["Row"] | null
      })
    | null

  team2:
    | (Database["public"]["Tables"]["team"]["Row"] & {
        group: Database["public"]["Tables"]["group"]["Row"] | null
        logo: Database["public"]["Tables"]["logo"]["Row"] | null
        logo_variant: Database["public"]["Tables"]["logo_variant"]["Row"] | null
      })
    | null
}

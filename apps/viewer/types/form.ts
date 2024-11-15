import type { Tables } from "~/types/database.types"

export type FormPlayer = {
  firstName: string
  lastName: string
  schoolClass: Tables<"class">
}

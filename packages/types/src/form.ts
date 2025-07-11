import type { Tables } from "./database.types.js"

export type FormPlayer = {
  firstName: string
  lastName: string
  schoolClass: Tables<"class">
}

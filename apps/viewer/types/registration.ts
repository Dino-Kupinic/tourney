import type { Tables } from "~/types/database.types"

export type RegistrationWithClass = Tables<"registration"> & {
  class: Tables<"class">
}

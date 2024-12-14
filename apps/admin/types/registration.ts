import type { Enums } from "~/types/database.types"

export type RegistrationColumn = {
  id: string
  name: string
  class: string
  expire_date: string
  status: Enums<"registration_status">
  allow_class_mixing: boolean
}

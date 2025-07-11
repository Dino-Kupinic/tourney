import type { Enums, Tables } from "./database.types.js"

export type RegistrationColumn = {
  id: string
  name: string
  class: string
  expire_date: string
  status: Enums<"registration_status">
  allow_class_mixing: boolean
}

export type RegistrationWithClass = Tables<"registration"> & {
  class: Tables<"class">
}

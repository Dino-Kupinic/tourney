import { serverSupabaseClient } from "#supabase/server"
import type { Database, Tables } from "~/types/database.types"

export default defineEventHandler(async (event) => {
  const data = await readBody<{
    expire_date: string
    teams: number
    year: string
  }>(event)
  const supabase = await serverSupabaseClient<Database>(event)

  type RegistrationDTO = Omit<Tables<"registration">, "id">
  const registrations: RegistrationDTO[] = []

  const { data: classes } = await supabase
    .from("class")
    .select("id, name, year")
    .eq("year", data.year)

  for (let i = 0; i < data.teams; i++) {
    classes?.forEach((item) => {
      registrations.push({
        class_id: item.id,
        expire_date: data.expire_date,
        status: "Ausstehend",
        name: `Team ${i + 1}`,
      })
    })
  }

  const { error } = await supabase.from("registration").insert(registrations)

  if (error) {
    throw createError({
      message: error.message,
      statusCode: 500,
    })
  }
})

import { serverSupabaseClient } from "#supabase/server"
import type { Database, Tables } from "~/types/database.types"

export default defineEventHandler(async (event) => {
  const { expire_date, teams, year } = await readBody<{
    expire_date: string
    teams: number
    year: string
  }>(event)

  const supabase = await serverSupabaseClient<Database>(event)

  type RegistrationDTO = Omit<Tables<"registration">, "id">

  const { data: classes, error: fetchError } = await supabase
    .from("class")
    .select("id, name, year")
    .eq("year", year)

  if (fetchError || !classes) {
    throw createError({
      message: fetchError?.message || "Failed to fetch classes.",
      statusCode: 500,
    })
  }

  const registrations: RegistrationDTO[] = Array.from({
    length: teams,
  }).flatMap((_, i) =>
    classes.map((item) => ({
      class_id: item.id,
      expire_date,
      status: "Ausstehend",
      hidden: false,
      name: `Team ${i + 1}`,
    })),
  )

  const { error: insertError } = await supabase
    .from("registration")
    .insert(registrations)

  if (insertError) {
    throw createError({
      message: insertError.message,
      statusCode: 500,
    })
  }
})

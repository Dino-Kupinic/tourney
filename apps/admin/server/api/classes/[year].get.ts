import { serverSupabaseClient } from "#supabase/server"
import type { Database } from "~/types/database.types"

export default defineEventHandler(async (event) => {
  const supabase = await serverSupabaseClient<Database>(event)
  const encodedYear = getRouterParam(event, "year")

  if (encodedYear === undefined) {
    throw createError({
      message: "Invalid Year URL parameter",
      statusCode: 400,
    })
  }

  const year = decodeURIComponent(encodedYear)

  const { data } = await supabase
    .from("class")
    .select("*")
    .eq("year", year)
    .order("name", { ascending: false })

  return data
})

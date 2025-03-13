import { serverSupabaseClient } from "#supabase/server"
import type { Database } from "~/types/database.types"

export default defineEventHandler(async (event) => {
  const supabase = await serverSupabaseClient<Database>(event)
  const { data } = await supabase
    .from("class")
    .select("*")
    .order("name", { ascending: false })

  return data
})

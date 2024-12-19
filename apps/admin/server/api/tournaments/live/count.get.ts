import { serverSupabaseClient } from "#supabase/server"
import type { Database } from "~/types/database.types"

export default defineEventHandler(async (event) => {
  const supabase = await serverSupabaseClient<Database>(event)
  const { count } = await supabase
    .from("tournament")
    .select("*", { count: "exact", head: true })
    .eq("is_live", true)

  return count
})

import { serverSupabaseClient } from "#supabase/server"
import type { Database } from "~/types/database.types"

export default defineEventHandler(async (event) => {
  const data = await readBody<string[]>(event)
  const supabase = await serverSupabaseClient<Database>(event)

  // const { error } = await supabase.from("registration").delete().in("id", data)
  const { error } = await supabase
    .from("registration")
    .update({ hidden: true })
    .in("id", data)

  if (error) {
    throw createError({
      message: error.message,
      statusCode: 500,
    })
  }
})

import type { Database } from "~/types/database.types"
import { serverSupabaseClient } from "#supabase/server"
import { H3Event } from "h3"

/**
 * Use the database client
 * @param event The incoming event
 */
export async function useDatabase(event: H3Event) {
  return await serverSupabaseClient<Database>(event)
}

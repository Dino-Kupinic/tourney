import { serverSupabaseClient } from "#supabase/server"
import type { Database } from "~/types/database.types"
import type { PlayerDTO } from "~/types/dto"

export default defineEventHandler(async (event) => {
  const supabase = await serverSupabaseClient<Database>(event)
  const { players } = await readBody<{
    players: PlayerDTO[]
  }>(event)

  if (!players) {
    throw createError({
      statusCode: 400,
      statusMessage: "Missing data field",
    })
  }

  const { error } = await supabase.from("player").insert(players)

  if (error) {
    throw createError({
      statusCode: 500,
      statusMessage: error.message,
    })
  }

  setResponseStatus(event, 201, "success")
})

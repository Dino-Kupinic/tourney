import type { PlayerDTO } from "@tourney/types"
export default defineEventHandler(async (event) => {
  const supabase = await useDatabase(event)
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

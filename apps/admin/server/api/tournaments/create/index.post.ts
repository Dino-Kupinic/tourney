import { serverSupabaseClient } from "#supabase/server"
import type { Database, Enums } from "~/types/database.types"
import type { TournamentDTO } from "~/types/dto"

type Body = {
  name: string
  rules: string
  start_date: string
  from: string
  to: string
  year: number
  sport: Enums<"sport_type">
  prizes: {
    first: string
    second: string
    third: string
    bonus: string
  }
  thumbnail_path: string
  location: string
  last_edited_by_id: string
  groups: number
  group_teams: number
}

export default defineEventHandler(async (event) => {
  const supabase = await serverSupabaseClient<Database>(event)
  const {
    name,
    rules,
    start_date,
    from,
    to,
    year,
    sport,
    prizes,
    thumbnail_path,
    location,
    last_edited_by_id,
    groups,
    group_teams,
  } = await readBody<Body>(event)

  if (
    !name ||
    !start_date ||
    !from ||
    !to ||
    !year ||
    !sport ||
    !prizes ||
    !thumbnail_path ||
    !location ||
    !last_edited_by_id ||
    !groups ||
    !group_teams
  ) {
    throw createError({
      statusCode: 400,
      statusMessage: "Missing data field(s)",
    })
  }

  type TournamentInsert = Omit<TournamentDTO, "created_at" | "is_live">
  const tournament: TournamentInsert = {
    name,
    rules,
    start_date,
    from,
    to,
    year,
    sport,
    prizes,
    thumbnail_path,
    location,
    last_edited_by_id,
    groups,
    group_teams,
  }

  const { error } = await supabase.from("tournament").insert(tournament)

  if (error) {
    throw createError({
      statusCode: 500,
      statusMessage: error.message,
    })
  }

  setResponseStatus(event, 201, "success")
})

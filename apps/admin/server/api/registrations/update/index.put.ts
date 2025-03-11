import { serverSupabaseClient } from "#supabase/server"
import type { Database, Enums } from "~/types/database.types"

export default defineEventHandler(async (event) => {
  const { registrations, status } = await readBody<{
    registrations: string[]
    status: Enums<"registration_status">
  }>(event)
  const supabase = await serverSupabaseClient<Database>(event)

  const { error } = await supabase
    .from("registration")
    .update({ status: status })
    .in("id", registrations)

  if (error) {
    throw createError({
      message: error.message,
      statusCode: 500,
    })
  }

  if (status === "Abgelehnt") {
    const { data: teams, error: teamsError } = await supabase
      .from("team")
      .select("id")
      .in("registration_id", registrations)

    if (teamsError) {
      throw createError({
        message: teamsError.message,
        statusCode: 500,
      })
    }

    if (teams && teams.length > 0) {
      const { error: updateError } = await supabase
        .from("team")
        .update({ group_id: null, tournament_id: null })
        .in("registration_id", registrations)

      if (updateError) {
        throw createError({
          message: updateError.message,
          statusCode: 500,
        })
      }
    }
  }

  setResponseStatus(event, 204, "success")
})

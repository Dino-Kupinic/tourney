import { serverSupabaseClient } from "#supabase/server"
import type { Database, Enums, Tables } from "~/types/database.types"
import { FormPlayer } from "~/types/form"
import { PlayerDTO, TeamDTO } from "~/types/dto"
import { RegistrationWithClass } from "~/types/registration"

type Body = {
  formPlayers: FormPlayer[]
  logo: Tables<"logo">
  logo_variant: Tables<"logo_variant">
  tournament: Tables<"tournament">
  registration: RegistrationWithClass
}

export default defineEventHandler(async (event) => {
  const supabase = await serverSupabaseClient<Database>(event)
  const { formPlayers, logo, logo_variant, registration, tournament } =
    await readBody<Body>(event)

  if (!formPlayers || !logo || !logo_variant || !registration) {
    throw createError({
      statusCode: 400,
      statusMessage: "Missing data fields",
    })
  }

  type TeamInsert = Omit<TeamDTO, "group">
  const team: TeamInsert = {
    name: registration.class.name,
    logo_id: logo.id,
    logo_variant_id: logo_variant.id ?? null,
    tournament_id: tournament.id,
    registration_id: registration.id,
  }

  const { data, error } = await supabase.from("team").insert(team).select()

  if (error) {
    throw createError({
      statusCode: 500,
      statusMessage: error.message,
    })
  }

  const players: PlayerDTO[] = formPlayers.map((formPlayer) => ({
    first_name: formPlayer.firstName,
    last_name: formPlayer.lastName,
    class: formPlayer.schoolClass.name,
    team_id: data[0].id,
  }))

  await $fetch("/api/players/create", {
    method: "POST",
    body: { players: players },
    async onRequestError({ error }) {
      throw createError({
        statusCode: 500,
        statusMessage: error.message,
      })
    },
  })

  const payload: {
    registration_id: string
    status: Enums<"registration_status">
  } = {
    registration_id: registration.id,
    status: "Abgesendet",
  }

  await $fetch("/api/registrations/update", {
    method: "PUT",
    body: payload,
    async onRequestError({ error }) {
      throw createError({
        statusCode: 500,
        statusMessage: error.message,
      })
    },
  })

  setResponseStatus(event, 201, "success")
})

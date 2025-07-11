import type { RegistrationDTO, Tables } from "@tourney/types"

export default defineEventHandler(async (event) => {
  const { expire_date, name, schoolClass, allow_class_mixing } =
    await readBody<{
      expire_date: string
      name: string
      schoolClass: Tables<"class">
      allow_class_mixing: boolean
    }>(event)

  const supabase = await useDatabase(event)
  const registration: RegistrationDTO = {
    class_id: schoolClass.id,
    expire_date,
    status: "Ausstehend",
    hidden: false,
    name,
    allow_class_mixing,
  }

  const { error } = await supabase.from("registration").insert(registration)

  if (error) {
    throw createError({
      message: error.message,
      statusCode: 500,
    })
  }

  setResponseStatus(event, 201)
})

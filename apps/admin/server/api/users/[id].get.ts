import { serverSupabaseServiceRole } from "#supabase/server"

export default defineEventHandler(async (event) => {
  const supabase = serverSupabaseServiceRole(event)
  const id = getRouterParam(event, "id")

  if (id === undefined) {
    throw createError({
      status: 400,
      message: "Missing id parameter",
    })
  }
  const { data, error } = await supabase.auth.admin.getUserById(id)
  return { data, error }
})

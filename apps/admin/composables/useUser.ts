import type { Database } from "~/types/database.types"

export const useUser = () => {
  const supabase = useSupabaseClient<Database>()
  const session = useSupabaseUser()

  const id = ref<string>(session.value?.id ?? "")
  const name = ref<string>(formatUsername(session.value?.email))
  const email = ref<string>(session.value?.email ?? "Unknown")
  const role = ref<string>(session.value?.user_metadata.role)
  const last_sign_in: ComputedRef<string> = useDateFormat(
    session.value?.last_sign_in_at ?? useNow(),
    "DD.MM.YYYY HH:mm:ss",
  )

  async function getUserById(user_id: string) {
    const { data, error } = await useFetch(`/api/users/${user_id}`)
    const user = data.value?.data.user
    if (error.value) {
      throw createError({
        status: 500,
        message: error.value.message,
      })
    }
    return user
  }

  function formatUsername(email: string | undefined) {
    if (email === undefined) {
      return "Unknown"
    }
    return email.slice(0, email.indexOf("@"))
  }

  async function login(email: string, password: string) {
    const { data, error } = await supabase.auth.signInWithPassword({
      email: email,
      password: password,
    })
    return { data, error }
  }

  async function logout() {
    await supabase.auth.signOut()
  }

  return {
    id,
    name,
    email,
    role,
    last_sign_in,
    login,
    logout,
    getUserById,
    formatUsername,
  }
}

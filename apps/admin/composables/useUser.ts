import type { Database } from "~/types/database.types"

export const useUser = () => {
  const supabase = useSupabaseClient<Database>()
  const session = useSupabaseSession()

  const index = session.value?.user.email?.indexOf("@")
  const name = ref<string>(
    session.value?.user.email?.slice(0, index) ?? "Unknown",
  )
  const email = ref<string>(session.value?.user.email ?? "Unknown")
  const role = ref<string>(session.value?.user.user_metadata.role)
  const last_sign_in: ComputedRef<string> = useDateFormat(
    session.value?.user.last_sign_in_at ?? useNow(),
    "DD.MM.YYYY HH:mm:ss",
  )

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
    name,
    email,
    role,
    last_sign_in,
    login,
    logout,
  }
}

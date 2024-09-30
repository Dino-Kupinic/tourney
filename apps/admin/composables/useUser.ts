export const useUser = () => {
  const supabase = useSupabaseClient()
  const session = useSupabaseSession()
  const index = session.value?.user.email?.indexOf("@")
  const name = ref<string>(
    session.value?.user.email?.slice(0, index) ?? "Unknown",
  )

  async function login() {}
  async function logout() {
    await supabase.auth.signOut()
  }

  return {
    name,
    logout,
  }
}

import { createClient } from "@supabase/supabase-js"

const supabaseUrl = process.env.SUPABASE_URL
const supabaseServiceKey = process.env.SUPABASE_SERVICE_KEY

const supabase = createClient(supabaseUrl, supabaseServiceKey)

async function createUser(email, password, role) {
  const { data, error } = await supabase.auth.admin.createUser({
    email,
    password,
    email_confirm: true,
    user_metadata: { role: role },
  })

  if (error) {
    console.error("Error creating user:", error)
    return
  }

  console.log("User created successfully:", data)
}

const usersToCreate = JSON.parse(process.env.USERS_TO_CREATE)

async function createAllUsers() {
  for (const user of usersToCreate) {
    await createUser(user.email, user.password, user.role)
  }
}

createAllUsers().then(() => console.log("User creation process complete."))

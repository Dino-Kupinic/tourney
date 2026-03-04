<script setup lang="ts">
import { z } from "zod"
import type { AuthFormField } from "@nuxt/ui"
import type { FormSubmitEvent } from "#ui/types"

definePageMeta({
  layout: false,
})

useHead({
  title: "Login",
})

const schema = z.object({
  email: z.string().email("Invalid email"),
  password: z.string(),
})

type Schema = z.output<typeof schema>
const fields: AuthFormField[] = [
  {
    name: "email",
    type: "email",
    label: "E-mail",
  },
  {
    name: "password",
    type: "password",
    label: "Passwort",
  },
]

const { login } = useUser()
const onSubmit = async (event: FormSubmitEvent<Schema>) => {
  const { data, error } = await login(
    event.data.email ?? "",
    event.data.password ?? "",
  )
  if (error) console.error(error)
  if (data.user) await navigateTo("/")
}
</script>

<template>
  <div class="flex h-dvh w-full items-center justify-center">
    <UCard class="w-full sm:w-96" variant="outline">
      <UAuthForm
        :schema="schema"
        :fields="fields"
        :submit="{ label: 'Einloggen', block: true }"
        @submit="onSubmit"
      >
        <template #header>
          <div class="flex flex-col items-center space-y-3">
            <Logo class="h-12 w-12" />
            <HeaderTitle>TOURNEY LOGIN</HeaderTitle>
          </div>
        </template>
        <template #footer>
          <div class="text-sm">
            <strong>Wo kriege ich meine Daten?</strong>
            <br />
            <span>
              Die Anmeldedaten werden Ihnen auf die Schul Mail
              <code>(@htl-steyr.ac.at)</code> geschickt.
            </span>
          </div>
        </template>
      </UAuthForm>
    </UCard>
  </div>
</template>

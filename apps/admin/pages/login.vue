<script setup lang="ts">
import { z } from "zod"
import type { FormSubmitEvent } from "#ui/types"

definePageMeta({
  layout: false,
})

const supabase = useSupabaseClient()
const schema = z.object({
  email: z.string().email("Invalid email"),
  password: z.string(),
})

type Schema = z.output<typeof schema>

const state = reactive({
  email: undefined,
  password: undefined,
})

const onSubmit = async (event: FormSubmitEvent<Schema>) => {
  const { data, error } = await supabase.auth.signInWithPassword({
    email: state.email ?? "",
    password: state.password ?? "",
  })
  if (error) console.log(error)
  if (data.user) await navigateTo("/")
}
</script>

<template>
  <div class="flex h-dvh w-full items-center justify-center">
    <UCard class="w-full sm:w-96">
      <template #header>
        <div class="flex flex-col items-center space-y-3">
          <Logo class="h-12 w-12" />
          <HeaderTitle>TOURNEY LOGIN</HeaderTitle>
        </div>
      </template>
      <UForm
        :schema="schema"
        :state="state"
        class="space-y-4"
        @submit="onSubmit"
      >
        <UFormGroup label="E-mail" name="email">
          <UInput v-model="state.email" />
        </UFormGroup>

        <UFormGroup label="Passwort" name="password">
          <UInput v-model="state.password" type="password" />
        </UFormGroup>

        <UButton type="submit" label="Einloggen" />
      </UForm>
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
    </UCard>
  </div>
</template>

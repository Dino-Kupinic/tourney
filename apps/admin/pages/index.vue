<script setup lang="ts">
const title = ref<string>("Home")
useHead({
  title: () => title.value,
})
</script>

<template>
  <BasePageHeader :title="title" />
  <BasePageContent>
    <div class="flex h-full w-full items-center justify-center">
      <div
        class="h-[32rem] w-[48rem] rounded-2xl bg-gray-100 p-12 dark:bg-gray-800"
      >
        <h1 class="font-serif text-3xl tracking-tight">
          Willkommen bei tourney.
        </h1>
        <div class="mt-6 flex h-full w-full flex-col gap-3">
          <div class="flex h-1/2 gap-3">
            <NuxtLink
              rel="noopener"
              target="_blank"
              to="https://htl-steyr.github.io/tourney/"
              class="hover:border-primary-500 dark:hover:border-primary-500 flex h-full w-2/3 flex-col justify-between rounded-lg border bg-gray-50 p-8 font-serif text-xl tracking-tight dark:border-gray-700 dark:bg-gray-900"
            >
              <p>Dokumentation</p>
              <UIcon
                name="i-heroicons-arrow-up-right"
                class="self-end text-gray-500"
                size="24"
              />
            </NuxtLink>
            <NuxtLink
              rel="noopener"
              target="_blank"
              to="https://github.com/HTL-Steyr/tourney"
              class="hover:border-primary-500 dark:hover:border-primary-500 flex h-full w-1/3 flex-col justify-between rounded-lg border bg-gray-50 p-8 font-serif text-xl tracking-tight dark:border-gray-700 dark:bg-gray-900"
            >
              <p>GitHub</p>
              <UIcon
                name="i-heroicons-arrow-up-right"
                class="self-end text-gray-500"
                size="24"
              />
            </NuxtLink>
          </div>
          <!-- TODO: update -->
          <NuxtLink
            rel="noopener"
            target="_blank"
            to="https://tourney.htl-steyr.at"
            class="hover:border-primary-500 dark:hover:border-primary-500 flex h-1/3 w-full flex-col justify-between rounded-lg border bg-gray-50 p-8 font-serif text-xl tracking-tight dark:border-gray-700 dark:bg-gray-900"
          >
            <p>Schüler-App</p>
            <UIcon
              name="i-heroicons-arrow-up-right"
              class="self-end text-gray-500"
              size="24"
            />
          </NuxtLink>
        </div>
      </div>
    </div>
  </BasePageContent>
</template>

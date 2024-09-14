<template>
  <div class="flex flex-col w-full h-full">
    <main
      class="border w-full h-full rounded-md border-gray-200 bg-gray-50 dark:bg-gray-900 dark:border-gray-800"
    >
      <slot />
    </main>
    <StatusBar />
  </div>
</template>

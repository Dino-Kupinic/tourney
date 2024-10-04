<template>
  <div class="flex h-full w-full flex-col">
    <main
      class="relative h-full w-full grow overflow-hidden rounded-md border border-gray-200 bg-gray-50 dark:border-gray-800 dark:bg-gray-900"
    >
      <slot />
    </main>
    <TheStatusBar />
  </div>
</template>

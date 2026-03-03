<template>
  <div class="flex h-full w-full flex-col">
    <main
      class="relative h-full w-full grow overflow-hidden rounded-md border border-neutral-200 bg-neutral-50 text-neutral-950 dark:border-neutral-800 dark:bg-neutral-900 dark:text-neutral-100"
    >
      <slot />
    </main>
    <TheStatusBar />
  </div>
</template>

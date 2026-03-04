<script setup lang="ts"></script>

<template>
  <div class="flex h-dvh w-full flex-col">
    <TheNavigation />
    <div class="grow border-neutral-200 p-6 pb-0 dark:border-neutral-800">
      <slot />
    </div>
  </div>
</template>

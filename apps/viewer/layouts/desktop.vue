<script setup lang="ts"></script>

<template>
  <div class="flex h-dvh w-full flex-col">
    <TheNavigation />
    <div
      class="m-auto w-[1024px] grow border-x border-gray-200 p-6 pb-0 2xl:w-[1366px] dark:border-gray-800"
    >
      <slot />
    </div>
  </div>
</template>

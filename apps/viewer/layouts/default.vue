<script setup lang="ts"></script>

<template>
  <div class="flex h-dvh w-full flex-col">
    <TheMobileHeader />
    <div class="mt-16 grow p-4 pb-16">
      <slot />
    </div>
    <TheNavigation />
  </div>
</template>

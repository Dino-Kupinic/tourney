<script setup lang="ts"></script>

<template>
  <div class="flex h-dvh w-full flex-col">
    <TheMobileHeader />
    <main class="mt-16 grow pb-16">
      <slot />
    </main>
    <TheNavigation />
  </div>
</template>

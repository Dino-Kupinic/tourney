<script setup lang="ts"></script>

<template>
  <div class="flex h-dvh w-full flex-col">
    <TheNavigation />
    <div class="grow">
      <slot />
    </div>
  </div>
</template>

<script setup lang="ts"></script>

<template>
  <div
    class="flex w-full flex-col items-center justify-between rounded-md border border-gray-200 px-6 py-3 shadow-sm dark:border-gray-700"
  >
    <div class="flex w-full items-center justify-between">
      <div class="flex flex-col items-center space-y-1">
        <UIcon name="i-game-icons-heartburn" size="24" />
        <div class="flex flex-col items-center">
          <p class="text-xs">1AHITN</p>
          <p class="text-xs text-gray-500">Gruppe C</p>
        </div>
      </div>
      <div class="flex h-full flex-col items-center justify-between">
        <p class="text-xs text-gray-500">Gruppenphase</p>
        <p>vs</p>
        <p class="text-xs text-gray-500">ca. 9:30</p>
      </div>
      <div class="flex flex-col items-center space-y-1">
        <UIcon name="i-game-icons-dragon-head" size="24" />
        <div class="flex flex-col items-center">
          <p class="text-xs">2AHITN</p>
          <p class="text-xs text-gray-500">Gruppe A</p>
        </div>
      </div>
    </div>
  </div>
</template>

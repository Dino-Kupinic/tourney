<script setup lang="ts"></script>

<template>
  <div>
    <TheMobileNavigation v-if="$device.isMobileOrTablet" />
    <TheDesktopNavigation v-else />
  </div>
</template>

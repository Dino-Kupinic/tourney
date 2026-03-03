<template>
  <UDashboardGroup
    storage-key="admin-dashboard"
    class="gap-2 bg-neutral-100 p-2 dark:bg-neutral-950"
  >
    <TheSideNavigation />
    <BasePageWrapper>
      <slot />
    </BasePageWrapper>
  </UDashboardGroup>
</template>

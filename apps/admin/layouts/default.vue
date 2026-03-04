<template>
  <UDashboardGroup
    storage-key="admin-dashboard"
    class="gap-1 bg-neutral-100 p-2 dark:bg-neutral-950"
  >
    <TheSideNavigation />
    <UDashboardSearch />
    <BasePageWrapper>
      <slot />
    </BasePageWrapper>
  </UDashboardGroup>
</template>

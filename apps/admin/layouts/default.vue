<template>
  <div class="flex flex-col h-dvh p-2">
    <TopNavigation />
    <div class="flex h-full">
      <SideNavigation />
      <BasePageWrapper>
        <slot />
      </BasePageWrapper>
    </div>
  </div>
</template>

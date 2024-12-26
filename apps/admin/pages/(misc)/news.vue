<script setup lang="ts">
const title = ref<string>("Aktuelles")
useHead({
  title: () => title.value,
})
const content = ref(`- Effective Date: \`08.09.2024\`
- Last Updated: \`08.09.2024\`

## Introduction

This Privacy Policy explains how we collect, use, and protect your personal information when you visit our
website [dino-kupinic.dev](https://www.dino-kupinic.dev) (the “Website”), in compliance with the General Data Protection
Regulation (GDPR) and other
relevant EU regulations. By using our website, you agree to the collection and use of information in accordance with
this policy.

### Who We Are

We respect your privacy and are committed to protecting your personal data. This Privacy Policy explains how we
handle the personal information you provide when you use our Website. For questions about this policy, you can
contact us at dinokupinic2006@gmail.com.

Visit the [Impressum](https://www.dino-kupinic.dev/impressum) page for more information about the Website owner.

### What Data We Collect

We collect several types of information from and about users of our Website, including:

- **Usage Data:** Information automatically collected about how you interact with the Website, including your IP
  address,
  browser type, pages visited, time spent on pages, and other analytical data.
- **Tracking and Cookies Data:** Cookies and similar technologies (e.g., pixels, web beacons) are used to collect
  information
  about your browsing behavior on the Website. For more details, see
  our [Cookie Policy](https://dino-kupinic.dev/cookies).

*We don't collect any information that can be used to identify you personally, such as your name or email address.*

### How We Use Your Data

We may use the information we collect for the following purposes:

- **To provide and maintain our Website:** We use the data to improve the functionality and performance of the site.
- **To analyze Website usage:** Using tools like [Vercel Analytics](https://vercel.com/docs/analytics)
  and [Microsoft Clarity](https://clarity.microsoft.com/), we collect anonymized usage data to
  understand how visitors use the Website and improve the user experience.
- **To communicate with you:** If you provide your email address through a contact form or other means, we may use it to
  respond to your inquiries or send updates.
- **To comply with legal obligations:** We may need to process your data to comply with laws and regulations, including
  GDPR.

### Cookies and Tracking Technologies

We use cookies and similar tracking technologies to track activity on our Website and hold certain information.
Cookies are files with a small amount of data that may include an anonymous unique identifier.

- **Necessary Cookies:** These are essential for the proper functioning of our Website. Without them, some parts of the
  site
  won’t work.
- **Analytics Cookies:** We use these cookies to collect information on how visitors interact with the Website, enabling
  us to
  improve user experience. For this purpose, we use services like Vercel Analytics and Microsoft Clarity.
- **Marketing Cookies:** If applicable, these cookies track user behavior for advertising purposes.
  You can control your cookie preferences at any time through our [Cookie Settings](https://dino-kupinic.dev/cookies).

For more details, please refer to our [Cookie Policy](https://dino-kupinic.dev/cookies).

### Data Sharing and Disclosure

We do not sell, trade, or otherwise transfer your personal data to outside parties except as described below:

- **Service Providers:** We may share your personal data with trusted third parties who assist us in running our
  Website (e.g., hosting, analytics, customer service). These third parties are bound by contractual agreements to
  maintain the confidentiality of your information.
- **Legal Requirements:** We may disclose your information if required by law, regulation, or government request.

### Your Data Protection Rights (GDPR)

If you are located in the European Economic Area (EEA), you have the following rights regarding your personal data:

| Right                     | Description                                                                   |
|---------------------------|-------------------------------------------------------------------------------|
| Access                    | request a copy of the personal data we hold about you.                        |
| Rectification             | request that we correct any inaccurate or incomplete data.                    |
| Erasure                   | request that we delete your personal data under certain circumstances         |
| Restriction of Processing | request that we limit how we process your data                                |
| Data Portability          | request that we transfer your personal data to another data controller        |
| Withdraw Consent          | You can withdraw consent for the processing of your personal data at any time |

*Please note that we can only fulfill requests that are possible. As an example, we cannot delete data already collected
by third-party services. We can also not give you access to data that does not exist, such as personal data that we do not
collect.*

To exercise any of these rights, please contact us at dinokupinic2006@gmail.com.

### Data Security

We take the security of your personal data seriously and use appropriate measures to protect it from unauthorized
access, alteration, disclosure, or destruction. However, please note that no method of transmission over the Internet
or method of electronic storage is completely secure, and we cannot guarantee absolute security.

### Data Retention

We will retain your personal data only for as long as is necessary for the purposes set out in this Privacy Policy,
or to comply with legal obligations. After that, we will securely delete your information.

### Third-Party Links

Our Website may contain links to other websites that are not operated by us. If you click on a third-party link, you
will be directed to that third party's site. We encourage you to review the Privacy Policy of every site you visit,
as we have no control over their content or data practices.

### Changes to This Privacy Policy

We may update this Privacy Policy from time to time. Any changes will be posted on this page, and the “Last Updated”
date at the top will be revised accordingly. We encourage you to review this Privacy Policy regularly to stay
informed about how we protect your information.

### Contact Us

If you have any questions or concerns about this Privacy Policy, or if you wish to exercise your data protection
rights, please contact us at dinokupinic2006@gmail.com.`)
const mode = useColorMode()
const theme = computed(() => {
  return mode.value === "dark" ? "vs-dark" : "vs-light"
})
</script>

<template>
  <BasePageHeader :title="title">
    <ToolbarContainer>
      <UButton
        label="Markdown Syntax"
        color="gray"
        size="xs"
        to="https://www.markdownguide.org/cheat-sheet/"
        target="_blank"
        rel="noopener noreferrer"
        icon="i-heroicons-arrow-top-right-on-square"
      />
      <UButton
        label="Änderungen speichern"
        variant="soft"
        size="xs"
        icon="i-heroicons-check"
      />
    </ToolbarContainer>
  </BasePageHeader>
  <ClientOnly>
    <div class="flex h-full w-full">
      <MonacoEditor
        v-model="content"
        lang="markdown"
        class="h-full w-3/5 border-r border-gray-200 dark:border-gray-700"
        :options="{ theme: theme }"
      />
      <div class="h-full w-2/5">
        <MDC
          class="h-full w-full overflow-auto bg-gray-100 p-3 dark:bg-gray-800"
          :value="content"
        />
      </div>
    </div>
    <template #fallback>
      <div
        class="flex h-full w-full items-center justify-center bg-gray-100 dark:bg-gray-900"
      >
        <UIcon name="i-svg-spinners-180-ring-with-bg" size="24" />
      </div>
    </template>
  </ClientOnly>
</template>

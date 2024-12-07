import { describe, expect, it, test } from "vitest"
import { setup, createPage } from "@nuxt/test-utils/e2e"

describe("Index page", async () => {
  const baseURL = "http://localhost:3001"
  await setup({
    host: baseURL,
  })

  it("displays a welcome message", async () => {
    const page = await createPage("/")
    expect(await page.textContent("h1")).toContain("Willkommen bei Tourney")
    expect(await page.textContent("p")).toContain(
      "Verfolge das Fußball-, Volleyball- und Basketballturnier der HTL Steyr live auf deinem Handy oder Laptop.",
    )
  })

  it("displays a continue button", async () => {
    const page = await createPage("/")
    expect(await page.getByTestId("continue-button").isVisible()).toBe(true)
  })

  it("navigates to the tournaments page", async () => {
    const page = await createPage("/")
    await page.getByTestId("continue-button").click()
    await page.waitForURL("**/tournaments")
    expect(page.url()).toBe(`${baseURL}/tournaments`)
  })

  test("if the copyright year is correct", async () => {
    const page = await createPage("/")
    expect(await page.getByTestId("copyright").textContent()).toContain(
      new Date().getFullYear(),
    )
  })
})

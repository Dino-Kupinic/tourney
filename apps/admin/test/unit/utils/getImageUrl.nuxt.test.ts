import { describe, it, expect, vi } from "vitest"
import { mockNuxtImport } from "@nuxt/test-utils/runtime"

vi.stubEnv("SUPABASE_URL", "http://127.0.0.1:54321")
vi.stubEnv("SUPABASE_KEY", "ABCDE")

mockNuxtImport("useSupabaseClient", () => {
  return () => ({
    storage: {
      from: vi.fn().mockReturnValue({
        getPublicUrl: vi.fn().mockImplementation((filePath) => ({
          data: {
            publicUrl: `https://example.com/storage/v1/object/public/images/${filePath}`,
          },
        })),
      }),
    },
  })
})

describe("getImageUrl", () => {
  it("should return the public URL for a given file path", () => {
    const filePath = "test-image.jpg"
    const expectedUrl =
      "https://example.com/storage/v1/object/public/images/test-image.jpg"

    const result = getImageUrl(filePath)

    expect(result).toBe(expectedUrl)
  })

  it("should handle file paths with subdirectories", () => {
    const filePath = "subfolder/test-image.png"
    const expectedUrl =
      "https://example.com/storage/v1/object/public/images/subfolder/test-image.png"

    const result = getImageUrl(filePath)

    expect(result).toBe(expectedUrl)
  })

  it("should handle file paths with special characters", () => {
    const filePath = "special_chars-test@image.jpg"
    const expectedUrl =
      "https://example.com/storage/v1/object/public/images/special_chars-test@image.jpg"

    const result = getImageUrl(filePath)

    expect(result).toBe(expectedUrl)
  })
})

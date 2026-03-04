export const AI_ASSISTANT_MODELS = ["gpt-4o-mini", "gpt-4o"] as const

export type AiAssistantModel = (typeof AI_ASSISTANT_MODELS)[number]

export const AI_ASSISTANT_DEFAULT_MODEL: AiAssistantModel = "gpt-4o-mini"

export const AI_ASSISTANT_MODEL_OPTIONS: Array<{
  label: string
  value: AiAssistantModel
}> = [
  {
    label: "GPT-4o mini",
    value: "gpt-4o-mini",
  },
  {
    label: "GPT-4o",
    value: "gpt-4o",
  },
]

export function isAiAssistantModel(value: unknown): value is AiAssistantModel {
  return (
    typeof value === "string" &&
    AI_ASSISTANT_MODELS.includes(value as AiAssistantModel)
  )
}

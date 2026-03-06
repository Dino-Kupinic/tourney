export const AI_ASSISTANT_MODELS = ["gpt-4.1-nano"] as const

export type AiAssistantModel = (typeof AI_ASSISTANT_MODELS)[number]

export const AI_ASSISTANT_DEFAULT_MODEL: AiAssistantModel = "gpt-4.1-nano"

export const AI_ASSISTANT_MODEL_OPTIONS: Array<{
  label: string
  value: AiAssistantModel
}> = [
  {
    label: "GPT 4.1 Nano",
    value: "gpt-4.1-nano",
  },
]

export function isAiAssistantModel(value: unknown): value is AiAssistantModel {
  return (
    typeof value === "string" &&
    AI_ASSISTANT_MODELS.includes(value as AiAssistantModel)
  )
}

import type { Tables } from "./database.types.js"

export type PrizeDetails = {
  first?: string
  second?: string
  third?: string
  bonus?: string
}

export type ParsedJsonTournament = Omit<Tables<"tournament">, "prizes"> & {
  prizes: PrizeDetails | null
}

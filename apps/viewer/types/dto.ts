import type { Tables } from "~/types/database.types"

type RegistrationDTO = Omit<Tables<"registration">, "id">
type PlayerDTO = Omit<Tables<"player">, "id" | "created_at" | "note">
type TeamDTO = Omit<Tables<"team">, "id" | "created_at">
type LogoDTO = Omit<Tables<"logo">, "id">
type LogoVariantDTO = Omit<Tables<"logo_variant">, "id">
type TournamentDTO = Omit<Tables<"tournament">, "id">
type ClassDTO = Omit<Tables<"class">, "id">
type MatchDTO = Omit<Tables<"match">, "id">
type GroupDTO = Omit<Tables<"group">, "id">
type ResultDTO = Omit<Tables<"result">, "id">

export type {
  RegistrationDTO,
  PlayerDTO,
  LogoDTO,
  LogoVariantDTO,
  TournamentDTO,
  ClassDTO,
  TeamDTO,
  MatchDTO,
  GroupDTO,
  ResultDTO,
}

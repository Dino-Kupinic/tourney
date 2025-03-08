export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  graphql_public: {
    Tables: {
      [_ in never]: never
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      graphql: {
        Args: {
          operationName?: string
          query?: string
          variables?: Json
          extensions?: Json
        }
        Returns: Json
      }
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
  public: {
    Tables: {
      class: {
        Row: {
          id: string
          name: string
          year: string
        }
        Insert: {
          id?: string
          name: string
          year: string
        }
        Update: {
          id?: string
          name?: string
          year?: string
        }
        Relationships: []
      }
      group: {
        Row: {
          id: string
          name: string
          tournament_id: string
        }
        Insert: {
          id?: string
          name: string
          tournament_id: string
        }
        Update: {
          id?: string
          name?: string
          tournament_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "group_tournament_id_fkey"
            columns: ["tournament_id"]
            isOneToOne: false
            referencedRelation: "tournament"
            referencedColumns: ["id"]
          },
        ]
      }
      logo: {
        Row: {
          id: string
          image_path: string
          name: string
        }
        Insert: {
          id?: string
          image_path: string
          name: string
        }
        Update: {
          id?: string
          image_path?: string
          name?: string
        }
        Relationships: []
      }
      logo_variant: {
        Row: {
          color: string
          id: string
          image_path: string
          logo_id: string
        }
        Insert: {
          color: string
          id?: string
          image_path: string
          logo_id: string
        }
        Update: {
          color?: string
          id?: string
          image_path?: string
          logo_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "logo_variant_logo_id_fkey"
            columns: ["logo_id"]
            isOneToOne: false
            referencedRelation: "logo"
            referencedColumns: ["id"]
          },
        ]
      }
      match: {
        Row: {
          end_time: string | null
          id: string
          is_live: boolean
          round: Database["public"]["Enums"]["tournament_phase"]
          start_time: string
          team1_id: string
          team2_id: string
          tournament_id: string
        }
        Insert: {
          end_time?: string | null
          id?: string
          is_live?: boolean
          round: Database["public"]["Enums"]["tournament_phase"]
          start_time: string
          team1_id: string
          team2_id: string
          tournament_id: string
        }
        Update: {
          end_time?: string | null
          id?: string
          is_live?: boolean
          round?: Database["public"]["Enums"]["tournament_phase"]
          start_time?: string
          team1_id?: string
          team2_id?: string
          tournament_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "match_team1_id_fkey"
            columns: ["team1_id"]
            isOneToOne: false
            referencedRelation: "group_standings"
            referencedColumns: ["team_id"]
          },
          {
            foreignKeyName: "match_team1_id_fkey"
            columns: ["team1_id"]
            isOneToOne: false
            referencedRelation: "team"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "match_team1_id_fkey"
            columns: ["team1_id"]
            isOneToOne: false
            referencedRelation: "team_standings"
            referencedColumns: ["team_id"]
          },
          {
            foreignKeyName: "match_team2_id_fkey"
            columns: ["team2_id"]
            isOneToOne: false
            referencedRelation: "group_standings"
            referencedColumns: ["team_id"]
          },
          {
            foreignKeyName: "match_team2_id_fkey"
            columns: ["team2_id"]
            isOneToOne: false
            referencedRelation: "team"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "match_team2_id_fkey"
            columns: ["team2_id"]
            isOneToOne: false
            referencedRelation: "team_standings"
            referencedColumns: ["team_id"]
          },
          {
            foreignKeyName: "match_tournament_id_fkey"
            columns: ["tournament_id"]
            isOneToOne: false
            referencedRelation: "tournament"
            referencedColumns: ["id"]
          },
        ]
      }
      player: {
        Row: {
          class: string
          created_at: string
          first_name: string
          id: string
          last_name: string
          note: string
          team_id: string
        }
        Insert: {
          class: string
          created_at?: string
          first_name: string
          id?: string
          last_name: string
          note?: string
          team_id: string
        }
        Update: {
          class?: string
          created_at?: string
          first_name?: string
          id?: string
          last_name?: string
          note?: string
          team_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "player_team_id_fkey"
            columns: ["team_id"]
            isOneToOne: false
            referencedRelation: "group_standings"
            referencedColumns: ["team_id"]
          },
          {
            foreignKeyName: "player_team_id_fkey"
            columns: ["team_id"]
            isOneToOne: false
            referencedRelation: "team"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "player_team_id_fkey"
            columns: ["team_id"]
            isOneToOne: false
            referencedRelation: "team_standings"
            referencedColumns: ["team_id"]
          },
        ]
      }
      registration: {
        Row: {
          allow_class_mixing: boolean
          class_id: string
          expire_date: string
          hidden: boolean
          id: string
          name: string
          status: Database["public"]["Enums"]["registration_status"]
        }
        Insert: {
          allow_class_mixing?: boolean
          class_id: string
          expire_date: string
          hidden?: boolean
          id?: string
          name: string
          status?: Database["public"]["Enums"]["registration_status"]
        }
        Update: {
          allow_class_mixing?: boolean
          class_id?: string
          expire_date?: string
          hidden?: boolean
          id?: string
          name?: string
          status?: Database["public"]["Enums"]["registration_status"]
        }
        Relationships: [
          {
            foreignKeyName: "registration_class_id_fkey"
            columns: ["class_id"]
            isOneToOne: false
            referencedRelation: "class"
            referencedColumns: ["id"]
          },
        ]
      }
      result: {
        Row: {
          id: string
          match_id: string
          team1_score: number
          team2_score: number
          winner_id: string | null
        }
        Insert: {
          id?: string
          match_id: string
          team1_score: number
          team2_score: number
          winner_id?: string | null
        }
        Update: {
          id?: string
          match_id?: string
          team1_score?: number
          team2_score?: number
          winner_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "result_match_id_fkey"
            columns: ["match_id"]
            isOneToOne: false
            referencedRelation: "match"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "result_match_id_fkey"
            columns: ["match_id"]
            isOneToOne: false
            referencedRelation: "matches_status"
            referencedColumns: ["match_id"]
          },
          {
            foreignKeyName: "result_winner_id_fkey"
            columns: ["winner_id"]
            isOneToOne: false
            referencedRelation: "group_standings"
            referencedColumns: ["team_id"]
          },
          {
            foreignKeyName: "result_winner_id_fkey"
            columns: ["winner_id"]
            isOneToOne: false
            referencedRelation: "team"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "result_winner_id_fkey"
            columns: ["winner_id"]
            isOneToOne: false
            referencedRelation: "team_standings"
            referencedColumns: ["team_id"]
          },
        ]
      }
      team: {
        Row: {
          created_at: string
          group_id: string | null
          id: string
          logo_id: string
          logo_variant_id: string | null
          name: string
          registration_id: string
          tournament_id: string
        }
        Insert: {
          created_at?: string
          group_id?: string | null
          id?: string
          logo_id: string
          logo_variant_id?: string | null
          name: string
          registration_id: string
          tournament_id: string
        }
        Update: {
          created_at?: string
          group_id?: string | null
          id?: string
          logo_id?: string
          logo_variant_id?: string | null
          name?: string
          registration_id?: string
          tournament_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "team_group_id_fkey"
            columns: ["group_id"]
            isOneToOne: false
            referencedRelation: "group"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "team_logo_id_fkey"
            columns: ["logo_id"]
            isOneToOne: false
            referencedRelation: "logo"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "team_logo_variant_id_fkey"
            columns: ["logo_variant_id"]
            isOneToOne: false
            referencedRelation: "logo_variant"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "team_registration_id_fkey"
            columns: ["registration_id"]
            isOneToOne: false
            referencedRelation: "registration"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "team_tournament_id_fkey"
            columns: ["tournament_id"]
            isOneToOne: false
            referencedRelation: "tournament"
            referencedColumns: ["id"]
          },
        ]
      }
      tournament: {
        Row: {
          created_at: string
          from: string
          group_teams: number
          groups: number
          id: string
          is_live: boolean
          last_edited_by_id: string
          location: string
          name: string
          prizes: Json | null
          rules: string | null
          sport: Database["public"]["Enums"]["sport_type"]
          start_date: string
          thumbnail_path: string
          to: string
          year: number
        }
        Insert: {
          created_at?: string
          from: string
          group_teams: number
          groups: number
          id?: string
          is_live?: boolean
          last_edited_by_id: string
          location?: string
          name: string
          prizes?: Json | null
          rules?: string | null
          sport: Database["public"]["Enums"]["sport_type"]
          start_date: string
          thumbnail_path: string
          to: string
          year: number
        }
        Update: {
          created_at?: string
          from?: string
          group_teams?: number
          groups?: number
          id?: string
          is_live?: boolean
          last_edited_by_id?: string
          location?: string
          name?: string
          prizes?: Json | null
          rules?: string | null
          sport?: Database["public"]["Enums"]["sport_type"]
          start_date?: string
          thumbnail_path?: string
          to?: string
          year?: number
        }
        Relationships: []
      }
      tournament_result: {
        Row: {
          position: number
          team_id: string
          tournament_id: string
        }
        Insert: {
          position: number
          team_id: string
          tournament_id: string
        }
        Update: {
          position?: number
          team_id?: string
          tournament_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "tournament_results_team_id_fkey"
            columns: ["team_id"]
            isOneToOne: false
            referencedRelation: "group_standings"
            referencedColumns: ["team_id"]
          },
          {
            foreignKeyName: "tournament_results_team_id_fkey"
            columns: ["team_id"]
            isOneToOne: false
            referencedRelation: "team"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "tournament_results_team_id_fkey"
            columns: ["team_id"]
            isOneToOne: false
            referencedRelation: "team_standings"
            referencedColumns: ["team_id"]
          },
          {
            foreignKeyName: "tournament_results_tournament_id_fkey"
            columns: ["tournament_id"]
            isOneToOne: false
            referencedRelation: "tournament"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      group_standings: {
        Row: {
          draws: number | null
          goal_difference: number | null
          goals_conceded: number | null
          goals_scored: number | null
          group_id: string | null
          losses: number | null
          points: number | null
          team_id: string | null
          team_name: string | null
          tournament_id: string | null
          wins: number | null
        }
        Relationships: [
          {
            foreignKeyName: "team_group_id_fkey"
            columns: ["group_id"]
            isOneToOne: false
            referencedRelation: "group"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "team_tournament_id_fkey"
            columns: ["tournament_id"]
            isOneToOne: false
            referencedRelation: "tournament"
            referencedColumns: ["id"]
          },
        ]
      }
      matches_status: {
        Row: {
          end_time: string | null
          match_id: string | null
          round: Database["public"]["Enums"]["tournament_phase"] | null
          start_time: string | null
          status: string | null
          team1_id: string | null
          team1_name: string | null
          team2_id: string | null
          team2_name: string | null
          tournament_id: string | null
        }
        Relationships: [
          {
            foreignKeyName: "match_team1_id_fkey"
            columns: ["team1_id"]
            isOneToOne: false
            referencedRelation: "group_standings"
            referencedColumns: ["team_id"]
          },
          {
            foreignKeyName: "match_team1_id_fkey"
            columns: ["team1_id"]
            isOneToOne: false
            referencedRelation: "team"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "match_team1_id_fkey"
            columns: ["team1_id"]
            isOneToOne: false
            referencedRelation: "team_standings"
            referencedColumns: ["team_id"]
          },
          {
            foreignKeyName: "match_team2_id_fkey"
            columns: ["team2_id"]
            isOneToOne: false
            referencedRelation: "group_standings"
            referencedColumns: ["team_id"]
          },
          {
            foreignKeyName: "match_team2_id_fkey"
            columns: ["team2_id"]
            isOneToOne: false
            referencedRelation: "team"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "match_team2_id_fkey"
            columns: ["team2_id"]
            isOneToOne: false
            referencedRelation: "team_standings"
            referencedColumns: ["team_id"]
          },
          {
            foreignKeyName: "match_tournament_id_fkey"
            columns: ["tournament_id"]
            isOneToOne: false
            referencedRelation: "tournament"
            referencedColumns: ["id"]
          },
        ]
      }
      team_standings: {
        Row: {
          draws: number | null
          goal_difference: number | null
          goals_conceded: number | null
          goals_scored: number | null
          losses: number | null
          points: number | null
          team_id: string | null
          team_name: string | null
          tournament_id: string | null
          wins: number | null
        }
        Relationships: [
          {
            foreignKeyName: "team_tournament_id_fkey"
            columns: ["tournament_id"]
            isOneToOne: false
            referencedRelation: "tournament"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Functions: {
      generate_final: {
        Args: {
          p_tournament_id: string
          p_start_time: string
          p_interval_minutes: number
        }
        Returns: undefined
      }
      generate_group_stage_matches: {
        Args: {
          p_tournament_id: string
          p_start_time: string
          p_interval_minutes: number
        }
        Returns: undefined
      }
      generate_quarterfinals: {
        Args: {
          p_tournament_id: string
          p_start_time: string
          p_interval_minutes: number
        }
        Returns: undefined
      }
      generate_semifinals: {
        Args: {
          p_tournament_id: string
          p_start_time: string
          p_interval_minutes: number
        }
        Returns: undefined
      }
      record_match_result: {
        Args: {
          p_match_id: string
          p_team1_score: number
          p_team2_score: number
        }
        Returns: undefined
      }
      update_tournament_results: {
        Args: {
          p_tournament_id: string
        }
        Returns: undefined
      }
    }
    Enums: {
      registration_status:
        | "Ausstehend"
        | "Abgesendet"
        | "Abgeschlossen"
        | "Abgelehnt"
      sport_type: "Fußball" | "Volleyball" | "Basketball"
      tournament_phase:
        | "Gruppenphase"
        | "Viertelfinale"
        | "Semifinale"
        | "Finale"
        | "Kleines Finale"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type PublicSchema = Database[Extract<keyof Database, "public">]

export type Tables<
  PublicTableNameOrOptions extends
    | keyof (PublicSchema["Tables"] & PublicSchema["Views"])
    | { schema: keyof Database },
  TableName extends PublicTableNameOrOptions extends { schema: keyof Database }
    ? keyof (Database[PublicTableNameOrOptions["schema"]]["Tables"] &
        Database[PublicTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = PublicTableNameOrOptions extends { schema: keyof Database }
  ? (Database[PublicTableNameOrOptions["schema"]]["Tables"] &
      Database[PublicTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : PublicTableNameOrOptions extends keyof (PublicSchema["Tables"] &
        PublicSchema["Views"])
    ? (PublicSchema["Tables"] &
        PublicSchema["Views"])[PublicTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  PublicTableNameOrOptions extends
    | keyof PublicSchema["Tables"]
    | { schema: keyof Database },
  TableName extends PublicTableNameOrOptions extends { schema: keyof Database }
    ? keyof Database[PublicTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = PublicTableNameOrOptions extends { schema: keyof Database }
  ? Database[PublicTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : PublicTableNameOrOptions extends keyof PublicSchema["Tables"]
    ? PublicSchema["Tables"][PublicTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  PublicTableNameOrOptions extends
    | keyof PublicSchema["Tables"]
    | { schema: keyof Database },
  TableName extends PublicTableNameOrOptions extends { schema: keyof Database }
    ? keyof Database[PublicTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = PublicTableNameOrOptions extends { schema: keyof Database }
  ? Database[PublicTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : PublicTableNameOrOptions extends keyof PublicSchema["Tables"]
    ? PublicSchema["Tables"][PublicTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  PublicEnumNameOrOptions extends
    | keyof PublicSchema["Enums"]
    | { schema: keyof Database },
  EnumName extends PublicEnumNameOrOptions extends { schema: keyof Database }
    ? keyof Database[PublicEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = PublicEnumNameOrOptions extends { schema: keyof Database }
  ? Database[PublicEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : PublicEnumNameOrOptions extends keyof PublicSchema["Enums"]
    ? PublicSchema["Enums"][PublicEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof PublicSchema["CompositeTypes"]
    | { schema: keyof Database },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof Database
  }
    ? keyof Database[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends { schema: keyof Database }
  ? Database[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof PublicSchema["CompositeTypes"]
    ? PublicSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never


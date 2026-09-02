// Gerado a partir do schema do Supabase (projeto OdontoFlow Dev).
// Não editar à mão — regenerar com o MCP/CLI do Supabase depois de cada migração
// (`supabase gen types typescript`) e commitar o resultado.

export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "14.5"
  }
  public: {
    Tables: {
      anamneses: {
        Row: {
          alergias: string | null
          atualizado_em: string
          criado_em: string
          doencas_sistemicas: string | null
          gestante: boolean | null
          historico_medico: string | null
          id: string
          medicamentos_uso_continuo: string | null
          observacoes_clinicas: string | null
          paciente_id: string
          possui_cardiopatia: boolean | null
          possui_diabetes: boolean | null
          possui_hipertensao: boolean | null
          preenchida_em: string | null
          profissional_id: string
          queixa_principal: string | null
          sangramento_excessivo: boolean | null
        }
        Insert: {
          alergias?: string | null
          atualizado_em?: string
          criado_em?: string
          doencas_sistemicas?: string | null
          gestante?: boolean | null
          historico_medico?: string | null
          id?: string
          medicamentos_uso_continuo?: string | null
          observacoes_clinicas?: string | null
          paciente_id: string
          possui_cardiopatia?: boolean | null
          possui_diabetes?: boolean | null
          possui_hipertensao?: boolean | null
          preenchida_em?: string | null
          profissional_id: string
          queixa_principal?: string | null
          sangramento_excessivo?: boolean | null
        }
        Update: {
          alergias?: string | null
          atualizado_em?: string
          criado_em?: string
          doencas_sistemicas?: string | null
          gestante?: boolean | null
          historico_medico?: string | null
          id?: string
          medicamentos_uso_continuo?: string | null
          observacoes_clinicas?: string | null
          paciente_id?: string
          possui_cardiopatia?: boolean | null
          possui_diabetes?: boolean | null
          possui_hipertensao?: boolean | null
          preenchida_em?: string | null
          profissional_id?: string
          queixa_principal?: string | null
          sangramento_excessivo?: boolean | null
        }
        Relationships: [
          {
            foreignKeyName: "anamneses_paciente_id_fkey"
            columns: ["paciente_id"]
            isOneToOne: false
            referencedRelation: "pacientes"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "anamneses_profissional_id_fkey"
            columns: ["profissional_id"]
            isOneToOne: false
            referencedRelation: "profissionais"
            referencedColumns: ["id"]
          },
        ]
      }
      consultorios: {
        Row: {
          atualizado_em: string
          cidade: string | null
          criado_em: string
          criado_por_usuario_id: string
          email: string | null
          endereco: string | null
          id: string
          nome: string
          observacoes: string | null
          telefone: string | null
          uf: string | null
        }
        Insert: {
          atualizado_em?: string
          cidade?: string | null
          criado_em?: string
          criado_por_usuario_id?: string
          email?: string | null
          endereco?: string | null
          id?: string
          nome: string
          observacoes?: string | null
          telefone?: string | null
          uf?: string | null
        }
        Update: {
          atualizado_em?: string
          cidade?: string | null
          criado_em?: string
          criado_por_usuario_id?: string
          email?: string | null
          endereco?: string | null
          id?: string
          nome?: string
          observacoes?: string | null
          telefone?: string | null
          uf?: string | null
        }
        Relationships: []
      }
      itens_plano_tratamento: {
        Row: {
          atualizado_em: string
          criado_em: string
          faces_dente: string[]
          id: string
          numero_dente: string | null
          observacao: string | null
          ordem: number
          plano_tratamento_id: string
          procedimento_id: string | null
          procedimento_nome: string
          regra_preco_nome: string | null
          regra_preco_procedimento_id: string | null
          status: string
          valor_estimado: number
          valor_final: number
        }
        Insert: {
          atualizado_em?: string
          criado_em?: string
          faces_dente?: string[]
          id?: string
          numero_dente?: string | null
          observacao?: string | null
          ordem?: number
          plano_tratamento_id: string
          procedimento_id?: string | null
          procedimento_nome: string
          regra_preco_nome?: string | null
          regra_preco_procedimento_id?: string | null
          status?: string
          valor_estimado?: number
          valor_final?: number
        }
        Update: {
          atualizado_em?: string
          criado_em?: string
          faces_dente?: string[]
          id?: string
          numero_dente?: string | null
          observacao?: string | null
          ordem?: number
          plano_tratamento_id?: string
          procedimento_id?: string | null
          procedimento_nome?: string
          regra_preco_nome?: string | null
          regra_preco_procedimento_id?: string | null
          status?: string
          valor_estimado?: number
          valor_final?: number
        }
        Relationships: [
          {
            foreignKeyName: "itens_plano_tratamento_plano_tratamento_id_fkey"
            columns: ["plano_tratamento_id"]
            isOneToOne: false
            referencedRelation: "planos_tratamento"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "itens_plano_tratamento_procedimento_id_fkey"
            columns: ["procedimento_id"]
            isOneToOne: false
            referencedRelation: "procedimentos"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "itens_plano_tratamento_regra_preco_procedimento_id_fkey"
            columns: ["regra_preco_procedimento_id"]
            isOneToOne: false
            referencedRelation: "regras_preco_procedimento"
            referencedColumns: ["id"]
          },
        ]
      }
      paciente_consultorios: {
        Row: {
          ativo: boolean
          atualizado_em: string
          consultorio_id: string
          criado_em: string
          id: string
          paciente_id: string
          profissional_id: string
        }
        Insert: {
          ativo?: boolean
          atualizado_em?: string
          consultorio_id: string
          criado_em?: string
          id?: string
          paciente_id: string
          profissional_id: string
        }
        Update: {
          ativo?: boolean
          atualizado_em?: string
          consultorio_id?: string
          criado_em?: string
          id?: string
          paciente_id?: string
          profissional_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "paciente_consultorios_consultorio_id_fkey"
            columns: ["consultorio_id"]
            isOneToOne: false
            referencedRelation: "consultorios"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "paciente_consultorios_paciente_id_fkey"
            columns: ["paciente_id"]
            isOneToOne: false
            referencedRelation: "pacientes"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "paciente_consultorios_profissional_id_fkey"
            columns: ["profissional_id"]
            isOneToOne: false
            referencedRelation: "profissionais"
            referencedColumns: ["id"]
          },
        ]
      }
      pacientes: {
        Row: {
          arquivado_em: string | null
          atualizado_em: string
          cpf: string | null
          criado_em: string
          criado_por_profissional_id: string
          data_nascimento: string | null
          email: string | null
          id: string
          nome: string
          observacoes: string | null
          telefone: string | null
        }
        Insert: {
          arquivado_em?: string | null
          atualizado_em?: string
          cpf?: string | null
          criado_em?: string
          criado_por_profissional_id: string
          data_nascimento?: string | null
          email?: string | null
          id?: string
          nome: string
          observacoes?: string | null
          telefone?: string | null
        }
        Update: {
          arquivado_em?: string | null
          atualizado_em?: string
          cpf?: string | null
          criado_em?: string
          criado_por_profissional_id?: string
          data_nascimento?: string | null
          email?: string | null
          id?: string
          nome?: string
          observacoes?: string | null
          telefone?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "pacientes_criado_por_profissional_id_fkey"
            columns: ["criado_por_profissional_id"]
            isOneToOne: false
            referencedRelation: "profissionais"
            referencedColumns: ["id"]
          },
        ]
      }
      planos_tratamento: {
        Row: {
          atualizado_em: string
          consultorio_id: string
          criado_em: string
          id: string
          observacoes: string | null
          paciente_id: string
          profissional_id: string
          status: string
          titulo: string
          valor_total_estimado: number
        }
        Insert: {
          atualizado_em?: string
          consultorio_id: string
          criado_em?: string
          id?: string
          observacoes?: string | null
          paciente_id: string
          profissional_id: string
          status?: string
          titulo?: string
          valor_total_estimado?: number
        }
        Update: {
          atualizado_em?: string
          consultorio_id?: string
          criado_em?: string
          id?: string
          observacoes?: string | null
          paciente_id?: string
          profissional_id?: string
          status?: string
          titulo?: string
          valor_total_estimado?: number
        }
        Relationships: [
          {
            foreignKeyName: "planos_tratamento_consultorio_id_fkey"
            columns: ["consultorio_id"]
            isOneToOne: false
            referencedRelation: "consultorios"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "planos_tratamento_paciente_id_fkey"
            columns: ["paciente_id"]
            isOneToOne: false
            referencedRelation: "pacientes"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "planos_tratamento_profissional_id_fkey"
            columns: ["profissional_id"]
            isOneToOne: false
            referencedRelation: "profissionais"
            referencedColumns: ["id"]
          },
        ]
      }
      procedimentos: {
        Row: {
          aplicacao: string
          ativo: boolean
          atualizado_em: string
          categoria: string | null
          consultas_previstas: number | null
          consultorio_id: string
          criado_em: string
          descricao: string | null
          exige_dente: boolean
          exige_face: boolean
          id: string
          nome: string
          permite_multiplas_faces: boolean
        }
        Insert: {
          aplicacao?: string
          ativo?: boolean
          atualizado_em?: string
          categoria?: string | null
          consultas_previstas?: number | null
          consultorio_id: string
          criado_em?: string
          descricao?: string | null
          exige_dente?: boolean
          exige_face?: boolean
          id?: string
          nome: string
          permite_multiplas_faces?: boolean
        }
        Update: {
          aplicacao?: string
          ativo?: boolean
          atualizado_em?: string
          categoria?: string | null
          consultas_previstas?: number | null
          consultorio_id?: string
          criado_em?: string
          descricao?: string | null
          exige_dente?: boolean
          exige_face?: boolean
          id?: string
          nome?: string
          permite_multiplas_faces?: boolean
        }
        Relationships: [
          {
            foreignKeyName: "procedimentos_consultorio_id_fkey"
            columns: ["consultorio_id"]
            isOneToOne: false
            referencedRelation: "consultorios"
            referencedColumns: ["id"]
          },
        ]
      }
      profissionais: {
        Row: {
          atualizado_em: string
          criado_em: string
          cro: string
          cro_uf: string
          email: string
          id: string
          nome: string
          observacoes: string | null
          telefone: string
          usuario_id: string
        }
        Insert: {
          atualizado_em?: string
          criado_em?: string
          cro: string
          cro_uf: string
          email: string
          id?: string
          nome: string
          observacoes?: string | null
          telefone: string
          usuario_id?: string
        }
        Update: {
          atualizado_em?: string
          criado_em?: string
          cro?: string
          cro_uf?: string
          email?: string
          id?: string
          nome?: string
          observacoes?: string | null
          telefone?: string
          usuario_id?: string
        }
        Relationships: []
      }
      profissional_consultorios: {
        Row: {
          ativo: boolean
          atualizado_em: string
          consultorio_id: string
          criado_em: string
          id: string
          profissional_id: string
        }
        Insert: {
          ativo?: boolean
          atualizado_em?: string
          consultorio_id: string
          criado_em?: string
          id?: string
          profissional_id: string
        }
        Update: {
          ativo?: boolean
          atualizado_em?: string
          consultorio_id?: string
          criado_em?: string
          id?: string
          profissional_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "profissional_consultorios_consultorio_id_fkey"
            columns: ["consultorio_id"]
            isOneToOne: false
            referencedRelation: "consultorios"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "profissional_consultorios_profissional_id_fkey"
            columns: ["profissional_id"]
            isOneToOne: false
            referencedRelation: "profissionais"
            referencedColumns: ["id"]
          },
        ]
      }
      regras_preco_procedimento: {
        Row: {
          ativo: boolean
          atualizado_em: string
          criado_em: string
          face_dente: string | null
          id: string
          material: string | null
          nivel_dificuldade: string | null
          nome_regra: string
          numero_dente: string | null
          observacoes: string | null
          procedimento_id: string
          quantidade_faces: number | null
          regiao_boca: string | null
          valor: number
        }
        Insert: {
          ativo?: boolean
          atualizado_em?: string
          criado_em?: string
          face_dente?: string | null
          id?: string
          material?: string | null
          nivel_dificuldade?: string | null
          nome_regra: string
          numero_dente?: string | null
          observacoes?: string | null
          procedimento_id: string
          quantidade_faces?: number | null
          regiao_boca?: string | null
          valor?: number
        }
        Update: {
          ativo?: boolean
          atualizado_em?: string
          criado_em?: string
          face_dente?: string | null
          id?: string
          material?: string | null
          nivel_dificuldade?: string | null
          nome_regra?: string
          numero_dente?: string | null
          observacoes?: string | null
          procedimento_id?: string
          quantidade_faces?: number | null
          regiao_boca?: string | null
          valor?: number
        }
        Relationships: [
          {
            foreignKeyName: "regras_preco_procedimento_procedimento_id_fkey"
            columns: ["procedimento_id"]
            isOneToOne: false
            referencedRelation: "procedimentos"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      colegas_do_consultorio: {
        Args: { consultorio_uuid: string }
        Returns: {
          cro: string
          cro_uf: string
          id: string
          nome: string
        }[]
      }
      profissionais_vinculados_paciente: {
        Args: { consultorio_uuid: string; paciente_uuid: string }
        Returns: {
          id: string
          nome: string
        }[]
      }
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never) = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never) = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never) = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends (DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never) = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends (PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never) = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {},
  },
} as const

defmodule ResuelveFC do
  @moduledoc """
  Documentation for `ResuelveFc`.
  """
  alias ResuelveFC.Calculo.Sueldo, as: Cal
  alias ResuelveFC.Calculo.Bono, as: Bono
  alias ResuelveFC.Validacion, as: Val
  require Logger
  @doc """
   Funcion de ejecución principal.

  ## Examples

      iex> ResuelveFc.main()
      :world

  """
  def main(_args) do
    Logger.info("**************************INICIO*****************************")
    str_json_niveles = Application.get_env(:resuelve_fc, ResuelveFC.Calculo)[:nivel] 
    str_file_in = Application.get_env(:resuelve_fc, ResuelveFC.Calculo)[:file_in] 
    str_file_out = Application.get_env(:resuelve_fc, ResuelveFC.Calculo)[:file_out] 
    res = Val.valida_env(str_json_niveles, str_file_in, str_file_out) 
    
    case res do
      :ok -> 
        map_niveles = JSON.decode(str_json_niveles)
        Logger.info("MAP: NIVELES: #{inspect map_niveles}")
        res_value_nivel = Val.valida_value_nivel(map_niveles)
        {:ok, list_json} = Val.valida_carga_json(str_file_in) 
        Logger.info("LIST: LIST_JSON: #{inspect list_json}")
        res_list_json = Val.valida_list_json(list_json)
        cond do 
          res_value_nivel != :ok -> 
            Logger.error("Error al validar el JSON de nivel: #{inspect res_value_nivel}")
          res_list_json != :ok -> 
            Logger.error("#{inspect res_list_json}")
          true ->
            {:ok, map_niveles} = map_niveles 
            {:ok, map_bono_equipo} = Bono.alcance(list_json, map_niveles)
            Logger.info("MAP: BONO_EQUIPO: #{inspect map_bono_equipo}")
             list_sueldos = Cal.sueldo(list_json, map_niveles, map_bono_equipo)    
            case File.open(str_file_out, [:write]) do 
              {:ok, file_out} ->
                str_json_salida = Poison.encode!(list_sueldos, pretty: true) 
                #{:ok, str_json_salida} = JSON.encode(list_sueldos)
                IO.binwrite(file_out, str_json_salida) 
                file_out |> File.close
                Logger.info("Se ha guardado de forma satisfactoria el archivo #{str_json_salida} con el json: \n #{str_json_salida}")
              error -> 
                Logger.error("Error al tratar de abrir archivo #{str_file_out}: #{inspect error}")
            end
        end
      _ ->
        Logger.error("#{inspect res}")
    end
    Logger.info("************************** FIN *****************************")
  end
end

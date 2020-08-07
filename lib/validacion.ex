defmodule ResuelveFC.Validacion do
  @moduledoc """
  Modulo que contiene las validaciones de formato, tipos, formato JSON.
  """
 
  require Logger
  @doc """
  Funcion para validar JSON principal con la organizacion. 
  """
  @spec valida_list_json(list()) :: atom()
  def valida_list_json(list_json) when is_list(list_json) do 
    _valida_list_json(list_json, 1)
  end
  @doc """
  Funcion auxiliar de valida_list_json para cuando no recibe el tipo correcto.. 
  """
  def valida_list_json(_) do 
    {:error, "El JSON leido desde el archivo no tiene el formato adecuado."}
  end
  @doc """
  Funcion para validar la carga de las variables de ambiente:
  $NIVELES :  JSON de niveles.
  $FILE_IN :  Path del archivo de entrada.
  $FILE_OUT :  Path del archivo de salida.
  """
  def valida_env(str_json_niveles, str_file_in, str_file_out) do 
    cond  do 
      str_json_niveles == nil ->
         {:error, "Variable de ambiente $NIVEL, no presente o es NULL."}
      str_file_in == nil  ->
         {:error, "Variable de ambiente $FILE_IN, no presente o es NULL."}
      str_file_out == nil  ->
        {:error, "Variable de ambiente $FILE_OUT, no presente o es NULL."}
      File.exists?(str_file_in) == false -> 
        {:error, "Archivo JSON #{str_file_in} no existe."}
      true ->
        :ok
    end
  end
  @doc """
  Funcion para validar la carga del archivo principal JSON. 
  """
  def valida_carga_json(str_file_in) do
      with {:ok, body} <- File.read(str_file_in),
           {:ok, list_json} <- JSON.decode(body) 
      do  
        {:ok, list_json} 
      else 
        err -> Logger.error("Error en la carga de archivo #{str_file_in} #{inspect err}") 
      end
  end
  @doc """
  Funcion para validar la carga de los parametros NIVEL. 
  """
  def valida_value_nivel({:ok, map}) when is_map(map) do 
    map |> Map.to_list |> valida_values_nivel(map)
  end
  @doc """
  Funcion auxiliar de valida_value_nivel. 
  """
  def valida_value_nivel(map) do
    {:error, "Error de formato de JSON variable de ambiente $NIVELES #{inspect map}"} 
  end
  defp valida_values_nivel([], _) do 
    :ok
  end
  defp valida_values_nivel([head|tail], map) do
    {key, value} = head
    #Logger.warn("HEAD: #{inspect map}")
    cond do 
      is_integer(value) == false ->
        {:error, "validar JSON de niveles, porque el valor de la llave(#{inspect key}):  #{inspect value}  no es un numero  entero."}
      value <= 0 ->  
        {:error, "validar JSON de niveles, porque el valor de la llave(#{inspect key}):  #{inspect value}  debe de ser mayor a cero."}
      true -> 
        valida_values_nivel(tail, map)
    end 
  end 
  defp  _valida_list_json([], _) do
    :ok
  end
  defp  _valida_list_json([head|tail], count) do
    str_nombre = Map.get(head, "nombre")
    str_equipo = Map.get(head, "equipo")
    str_nivel = Map.get(head, "nivel")
    int_goles = Map.get(head, "goles")
    flt_sueldo = Map.get(head, "sueldo")
    flt_bono = Map.get(head, "bono")
    validacion_aux = _valida_list_json_aux(str_nombre, str_equipo, str_nivel, count, head)
    cond do 
      validacion_aux != :ok ->
        validacion_aux
      is_integer(int_goles) != true -> 
        {:error, "El parametro goles debe de ser tipo Intenger, registro numero #{count}: #{inspect head}"}
      (is_integer(flt_sueldo) != true) && (is_float(flt_sueldo) != true) -> 
        {:error, "El parametro sueldo debe de ser tipo Intenger o Float, registro numero #{count}: #{inspect head}"}
       (is_integer(flt_bono) != true) && (is_float(flt_bono) != true) -> 
         {:error, "El parametro bono debe de ser tipo Intenger o Float, registro numero #{count}: #{inspect head}"}
      is_duplicate?(str_nombre, tail) == true ->    
         {:error, "El registro nombre no puede estar duplicado, registro numero #{count} nombre: #{inspect str_nombre}"} 
      true ->
        _valida_list_json(tail, count + 1 ) 
     end 
  end
  defp _valida_list_json_aux(str_nombre, str_equipo, str_nivel, count, head) do 
    cond do
      str_nombre == nil || str_nombre == ""  -> 
        {:error, "El parametro nombre no debe de ser nil,  registro numero #{count}: #{inspect head}"}
      str_equipo == nil || str_equipo == "" -> 
        {:error, "El parametro equipo no debe de ser nil,  registro numero #{count}: #{inspect head}"}
      str_nivel == nil || str_nivel == "" -> 
        {:error, "El parametro nivel no debe de ser nil,  registro numero #{count}: #{inspect head}"}
      is_bitstring(str_nombre) != true -> 
        {:error, "El parametro nombre debe de ser tipo String, registro numero #{count}: #{inspect head}"}
      is_bitstring(str_equipo) != true -> 
        {:error, "El parametro equipo debe de ser tipo String, registro numero #{count}: #{inspect head}"}
      is_bitstring(str_nivel) != true -> 
        {:error, "El parametro nivel debe de ser tipo String, registro numero #{count}: #{inspect head}"}
       true ->
         :ok 
    end
  end
  defp is_duplicate?(_, []) do 
    false
  end
  defp is_duplicate?(str_nombre, [head|tail]) do 
    if str_nombre == Map.get(head, "nombre") do 
      true 
    else
      is_duplicate?(str_nombre, tail)
    end
  end
end

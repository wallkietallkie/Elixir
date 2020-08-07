defmodule ResuelveFC.Calculo.Bono do 
  @moduledoc """
    Este modulo tiene la finalidad de obtener un mapa de los niveles vs los goles equipo , x equipo:
     
     %{"azul" => %{goles_limit: 25, goles_sum: 37}, "rojo" => %{goles_limit: 25, goles_sum: 19}}
     
     Donde: 
      
     El parametro goles_limit, es la sumatoria de los niveles limite del equipo.
     El parametro goles_sum, es ls sumatoria de goles del equipo.

     Estos parametros sirven para el calculo final del equipo.

  """
  @moduledoc since: "1.0.0"

  require Logger
  @doc """
   Funcion principal
     ## Parametros 
     - list:  List que representa la lista de jugadores. 
     - map_niveles:  Map con los niveles leidos a partir de la variable de ambiente $NIVELES
     ## Ejemplos: 

    iex> ResuelveFC.Calculo.Bono.alcance([%{"bono" => 25000, "equipo" => "rojo", "goles" => 10, "nivel" =>    "C", "nombre" => "Juan Perez", "sueldo" => 50000, "sueldo_completo" => nil}, %{"bono" => 30000,           "equipo" => "azul", "goles" => 30, "nivel" => "Cuauh", "nombre" => "EL Cuauh", "sueldo" => 100000,"sueldo_completo" => nil}, %{"bono" => 10000, "equipo" => "azul", "goles" => 7, "nivel" => "A", "nombre" => "Cosme Fulanito", "sueldo" => 20000, "sueldo_completo" => nil}, %{"bono" => 15000, "equipo" => "rojo", "goles" => 9, "nivel" => "B", "nombre" => "El Rulo", "sueldo" => 30000, "sueldo_completo" => nil}], %{"A" => 5, "B" => 10, "C" => 15, "Cuauh" => 20})

  {:ok,
   %{
    "azul" => %{goles_limit: 25, goles_sum: 37},
    "rojo" => %{goles_limit: 25, goles_sum: 19}
    }}

   
  """
  @spec alcance(list(), map()) :: map() 
  def alcance(list, map_niveles) do
    alcance(list, map_niveles, %{}) 
  end
  @spec alcance(list(), map(), map()) :: tuple() 
  defp alcance([], _, map_bono_x_equipo) do 
    {:ok, map_bono_x_equipo}
  end
  @spec alcance(list(), map(), map()) :: map() 
  defp alcance([head|tail], map_niveles, map_bono_x_equipo) do
    Logger.debug("Head: #{inspect head}")
    str_equipo = Map.get(head, "equipo")
    str_nivel = Map.get(head, "nivel")
    int_goles = Map.get(head, "goles")
    Logger.debug("String equipo: #{ inspect str_equipo }, String nivel: #{ inspect str_nivel}")
    result =
    cond do
      Map.has_key?( map_niveles, str_nivel) != true ->
        {:error, "No es posible encontrar el  nivel:  \"#{inspect str_nivel} \" debido a que no existe en el archivo de configuracion \"config.exs\"."}
      Map.has_key?(map_bono_x_equipo, str_equipo) == false -> 
        value_nivel = Map.get(map_niveles, str_nivel)
        {:new, %{goles_sum: int_goles, goles_limit: value_nivel}} 
      Map.has_key?(map_bono_x_equipo, str_equipo) == true -> 
        map_value = Map.get(map_bono_x_equipo, str_equipo) 
        value_nivel = Map.get(map_niveles, str_nivel) 
        {:replace, %{ 
          goles_sum: int_goles + map_value.goles_sum, 
          goles_limit: map_value.goles_limit + value_nivel}} 
    end
    
    case result do 
      {:error, _} -> 
        result
      {:new, map_new} -> 
        alcance(tail, map_niveles, Map.put_new(map_bono_x_equipo, str_equipo, map_new)) 
      {:replace, map_replace} -> 
        alcance(tail, map_niveles, Map.replace!(map_bono_x_equipo, str_equipo, map_replace)) 
    end 
  end
end

defmodule ResuelveFC.Calculo.Sueldo do 
  @moduledoc """
    Este modulo tiene la finalidad de realizar el calculo final del sueldo, la salida final es una lista :
     
     List sueldos final: [%{bono: 25000, equipo: "rojo", goles: 10, goles_minimo: 15, nombre: "Juan Perez", sueldo_completo: 67833.34}, %{bono: 30000, equipo: "azul", goles: 30, goles_minimo: 20, nombre: "EL Cuauh", sueldo_completo: 130000}, %{bono: 10000, equipo: "azul", goles: 7, goles_minimo: 5, nombre: "Cosme Fulanito", sueldo_completo: 30000}, %{bono: 15000, equipo: "rojo", goles: 9, goles_minimo: 10, nombre: "El Rulo", sueldo_completo: 42450.0}]

     
     Donde: 
      
     sueldo_completo , es el sueldo resultado del calculo de sueldo + su respectivo bono.


  """
  @moduledoc since: "1.0.0"

  require Logger
  
  @doc """
   Funcion principal
     ## Parametros 
     - list:  List que representa la lista de jugadores. 
     - map_niveles:  Map con los niveles leidos a partir de la variable de ambiente $NIVELES
     - map_bono_equipo: Map con  los niveles vs los goles equipo , x equipo . Obtenida de la aplicacion de la función: ResuelveFC.Calculo.Bono.alcance(...)

     ## Ejemplos: 

    iex > ResuelveFC.Calculo.Sueldo.sueldo([%{"bono" => 25000, "equipo" => "rojo", "goles" => 10, "nivel" => "C", "nombre" => "Juan Perez", "sueldo" => 50000, "sueldo_completo" => nil}, %{"bono" => 30000, "equipo" => "azul", "goles" => 30, "nivel" => "Cuauh", "nombre" => "EL Cuauh", "sueldo" => 100000, "sueldo_completo" => nil}, %{"bono" => 10000, "equipo" => "azul", "goles" => 7, "nivel" => "A", "nombre" => "Cosme Fulanito", "sueldo" => 20000, "sueldo_completo" => nil}, %{"bono" => 15000, "equipo" => "rojo", "goles" => 9, "nivel" => "B", "nombre" => "El Rulo", "sueldo" => 30000, "sueldo_completo" => nil}], %{"A" => 5, "B" => 10, "C" => 15, "Cuauh" => 20}, %{"azul" => %{goles_limit: 25, goles_sum: 37}, "rojo" => %{goles_limit: 25, goles_sum: 19}})  
  [
  %{
    bono: 25000,
    equipo: "rojo",
    goles: 10,
    goles_minimo: 15,
    nombre: "Juan Perez",
    sueldo_completo: 67833.34
  },
  %{
    bono: 30000,
    equipo: "azul",
    goles: 30,
    goles_minimo: 20,
    nombre: "EL Cuauh",
    sueldo_completo: 130000
  },
  %{
    bono: 10000,
    equipo: "azul",
    goles: 7,
    goles_minimo: 5,
    nombre: "Cosme Fulanito",
    sueldo_completo: 30000
  },
  %{
    bono: 15000,
    equipo: "rojo",
    goles: 9,
    goles_minimo: 10,
    nombre: "El Rulo",
    sueldo_completo: 42450.0
  }
  ]
  """
  @spec sueldo(list(), map(), map()) :: list()  
  def sueldo(list, map_niveles, map_bono_equipo) do 
     sueldo(list, map_niveles, map_bono_equipo, []) 
  end 
  @spec sueldo(list(), map(), map(), list()) :: list() 
  defp sueldo([], _, _, list_sueldos) do 
     list_sueldos
  end
  @spec sueldo(list(), map(), map(), list()) :: list() 
  defp sueldo([head|tail], map_niveles, map_bono_equipos, list_sueldos) do 
    
    str_nivel = Map.get(head, "nivel")
    str_nombre = Map.get(head, "nombre")
    str_equipo = Map.get(head, "equipo")
    flt_sueldo = Map.get(head, "sueldo")
    flt_bono = Map.get(head, "bono")
    int_goles = Map.get(head, "goles")
    Logger.debug("******Head:\n #{ inspect head} \n #{inspect map_niveles}\n head.nivel: #{inspect str_nivel}")
    list_sueldo = 
    cond do 
      Map.has_key?( map_niveles, str_nivel) != true ->
        [%{nombre: str_nombre, 
          equipo: str_equipo,
          error: "No se encontro un nivel configurado para " <> str_nivel <> ", favor de configurar el nivel en el archivo de \"config.exs\"." 
         } ] 
      flt_sueldo < 0 -> 
        [%{nombre: str_nombre, 
          equipo: str_equipo,
          error: "El sueldo no puede ser negativo." 
         } ] 
      flt_bono < 0 -> 
        [%{nombre: str_nombre, 
          equipo: str_equipo,
          error: "El bono no puede ser negativo." 
         } ] 
      int_goles < 0 -> 
        [%{nombre: str_nombre, 
          equipo: str_equipo,
          error: "Los goles no pueden ser negativos." 
        }] 
      true ->
        [
          %{nombre: str_nombre, 
            equipo: str_equipo,
            goles_minimo: Map.get(map_niveles, str_nivel), 
            goles: int_goles, 
            bono: flt_bono,
            sueldo: flt_sueldo, 
            sueldo_completo: aplica_calculo(flt_sueldo,
                                            int_goles,
                                            flt_bono, 
                                            Map.get(map_niveles, str_nivel),
                                            Map.get(map_bono_equipos, str_equipo))
          }
        ]
    end
   sueldo(tail, map_niveles, map_bono_equipos, list_sueldos ++ list_sueldo)    
  end 
  @spec aplica_calculo(float(), integer(), float(), integer(), map()) :: float() 
  defp aplica_calculo(sueldo, goles, bono, goles_nivel, map_equipo) do
    #Logger.debug("Sueldo: #{sueldo}, Bono: #{bono}")
    #Logger.debug("Equipo Goles Sum: #{map_equipo.goles_sum} / Goles Limit: #{map_equipo.goles_limit}")
    #Logger.debug("Individual Goles Sum: #{goles} / Goles Nivel: #{goles_nivel}") 
    flt_equipo = map_equipo.goles_sum / map_equipo.goles_limit
    flt_personal = goles / goles_nivel
    bono_50 = bono / 2
    bono = 
    cond  do 
      flt_equipo >= 1 &&  flt_personal >= 1  -> 
        bono
      flt_equipo >= 1 &&  flt_personal < 1  ->
        bono_50 +  bono_50 * flt_personal
      flt_equipo &&  flt_personal >= 1  -> 
        bono_50 * flt_equipo + bono_50 
      true ->
        bono_50 * flt_equipo + bono_50 * flt_personal
    end 
    redondea(sueldo + bono)
  end
  @spec redondea(float()) :: float() 
  defp redondea(value) do 
    case is_float(value) do
      true ->   
        Float.ceil(value, 2)
      false -> 
        value
    end
  end
end

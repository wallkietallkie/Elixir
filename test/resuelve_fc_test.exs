defmodule ResuelveFcTest do
 require Logger
   
  @moduledoc """ 
    Este modulo es el encargado de probar la aplicación ResuelveFC

  """
  @moduledoc since: "1.0.0"

  use ExUnit.Case
  doctest ResuelveFc
  alias ResuelveFC.Calculo.Sueldo, as: Cal
  alias ResuelveFC.Calculo.Bono, as: Bono

  def str_json do 
  "[{
      \"nombre\": \"Juan Perez\",
      \"nivel\": \"C\",
      \"goles\": 10,
      \"sueldo\": 50000,
      \"bono\": 25000,
      \"sueldo_completo\": null,
      \"equipo\": \"rojo\"
   },
   {
      \"nombre\": \"EL Cuauh\",
      \"nivel\": \"Cuauh\",
      \"goles\": 30,
      \"sueldo\": 100000,
      \"bono\": 30000,
      \"sueldo_completo\": null,
      \"equipo\": \"azul\"
   },
   {
      \"nombre\": \"Cosme Fulanito\",
      \"nivel\": \"A\",
      \"goles\": 7,
      \"sueldo\": 20000,
      \"bono\": 10000,
      \"sueldo_completo\": null,
      \"equipo\": \"azul\"

   },
   {
      \"nombre\": \"El Rulo\",
      \"nivel\": \"B\",
      \"goles\": 9,
      \"sueldo\": 30000,
      \"bono\": 15000,
      \"sueldo_completo\" :null,
      \"equipo\": \"rojo\"

   }]"
  end

  @doc """
    Prueba las variables de ambiente, antes de ejecutar esta prueba realizar la configuracion de la variable de ambiente :
  UNIX: 
      export NIVEL="{\"a\": 5, \"b\": 10, \"c\": 15, \"cuauh\": 20}"
  """
  @doc since: "1.0.0" 
  test "test variable de ambiente" do  
    Logger.info("test variable de ambiente")
    str_json_nivel = Application.get_env(:resuelve_fc, ResuelveFC.Calculo)[:nivel] 
    Logger.debug("Str JSON nivel: #{inspect str_json_nivel}")
    assert  str_json_nivel != nil 
    {status, map_niveles} = JSON.decode(str_json_nivel)
    Logger.debug("Status: #{inspect status} , List: #{inspect map_niveles}")
    assert status != :error
  end
  @doc """
    Prueba para obtener el map de la sumatoria limite de los equipos,
  """
  @doc since: "1.0.0" 
  test "test limite de goles x equipo" do 
    Logger.info("test limite de goles x equipo" )
    str_json_nivel = Application.get_env(:resuelve_fc, ResuelveFC.Calculo)[:nivel] 
    Logger.debug("Str JSON nivel: #{inspect str_json_nivel}")
    {status, map_niveles} = JSON.decode(str_json_nivel)
    Logger.debug("Status: #{inspect status} , List: #{inspect map_niveles}")
    
    {status, list} = JSON.decode(str_json)

    Logger.debug(" List from json #{inspect list}")
    assert(is_list(list) == true)
    
    {status, map} = Bono.alcance(list , map_niveles)
    Logger.debug("status: #{inspect status} map: #{inspect map}")
    assert status == :ok
  end

  @doc """
    Prueba que resuelve el ejercicio ejemplo propuesto en: 

    https://github.com/resuelve/prueba-ing-backend 
   
    Seccion la prueba.
    
  """
  @doc since: "1.0.0" 
  test "recibe JSON happy path" do 
    Logger.info("recibe JSON happy path")
    {status, list} = JSON.decode(str_json)    
    str_json_nivel = Application.get_env(:resuelve_fc, ResuelveFC.Calculo)[:nivel] 
    {status, map_niveles} = JSON.decode(str_json_nivel)
    Logger.debug("Map niveles: #{inspect map_niveles}")
    {status, map_bono_equipo} = Bono.alcance(list, map_niveles)
    Logger.debug("status: #{inspect status} map: #{inspect map_bono_equipo}")

    list_sueldos = Cal.sueldo(list, map_niveles, map_bono_equipo)
    Logger.debug("List sueldos final: #{inspect list_sueldos}")

  end
end

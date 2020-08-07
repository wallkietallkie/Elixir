# RTD

_Proyecto que resuelve el problema planteado para el calculo de sueldos de ResuelveFC: 
  Recibe archivo JSON, en archivo de entrada.
  Carga configuración de Niveles. 
  Calcula desempeño por equipos
  Procesa JSON vs Niveles/Desempeño equipo, guarda en archivo salida. 
  
 

## Comenzando 🚀


git clone 
cd resuelve_fc
mix deps.get



### Pre-requisitos 📋

_UNIX: LINUX / MAC
_Elixir 1.10 o mayor
_Erlang OTP  correspondiente a ELIXIR

### Ejecución 🔧

_Se tiene que ejecutar las variables de ambiente contenidas en el archivo "env" . Se pueden agregar al profile o ejecutar antes de realizar la version productiva, donde:
    
   NIVEL: JSON para cargar los niveles de jugadores.
   FILE_IN: Path de archivo JSON de entrada. 
   FILE_OUT: Path de archivo JSON de salida, con el campo sueldo_completo.
   LOG_RESUELVE: Path donde se graba el 

_Ejemplo:
 
Cargando variables de ambiente:
```
$ export NIVEL="{ \"A\": 5, \"B\": 10, \"C\": 15, \"Cuauh\": 20 }"
$ export FILE_OUT="./salida.json"
$ export FILE_IN="./entrada.json"
$ export LOG_RESUELVE="./resuelve_fc.log"
$ MIX_ENV=prod
```

Generando binario:

```
$ mix escript.build
Generated escript resuelve_fc with MIX_ENV=prod
$ ls resuelve_fc
resuelve_fc 
```

Ejecutando: 

```
$ ./resuelve_fc

```

* Toma como entrada:  
 ** Json que se encuentra guardado en la variable $FILE_IN, en este caso el archivo "./entrada.json".
 ** Variable de ambiente con JSON que esta en la variable de ambiente $NIVEL.
* Procesa la información para guardar el archivo configurado en el archivo $FILE_OUT, en este caso de "./salida.json".
* 


## Ejecutando las pruebas ⚙️

_mix test test/resuelve_fc_test.exs


### Validaciones aplicadas ⌨️

_Validacion de formato JSON. 
_Validacion de tipo de datos. 
_Validacion de duplicación de registro de jugadores. 
_Validaciones de campos necesarios. 
_validaciones de FILE.IO.  



## Autores ✒️


* **Erik Alejandro Linares Mendoza** - *Trabajo Inicial* - [alejandroerik](https://github.com/alejandroerik/ale8583) - [email](erik.linares@gmail.com) - [Tel](55 26 73 90 44)


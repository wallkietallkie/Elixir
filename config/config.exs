# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :logger, 
       backends: [:console, {LoggerFileBackend, :file_log}],
       format: "\n$date $time $metadata[$level] $levelpad$message ",
       metadata: [:module, :line]

config :logger, :file_log, 
  path: System.get_env("LOG_RESUELVE"),
  level: :info,
  rotate: %{max_bytes: 556000, keep: 100},
  format: "\n$date $time $metadata[$level] $levelpad$message ",
  metadata: [:module, :line]

#config :logger, :console,
#  level: :debug,
#  format: "\n$date $time $metadata[$level] $levelpad$message ",
#  metadata: [:module, :line]

config :resuelve_fc, ResuelveFC.Calculo ,
       #Application.get_env(:busi_api, BusiApi.Nodes)[:url]
       #nivel: %{ a: 5, b: 10, c: 15, cuauh: 20 }
       nivel: System.get_env("NIVEL"),
       file_in: System.get_env("FILE_IN"),
       file_out: System.get_env("FILE_OUT")

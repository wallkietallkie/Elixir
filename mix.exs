defmodule ResuelveFc.MixProject do
  use Mix.Project

  def project do
    [
      app: :resuelve_fc,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(), 
      escript: escript()
    ]
  end

  def escript do
    [main_module: ResuelveFC]
  end
  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:json, "~> 1.2"},
      {:poison, "~> 3.1"},
      {:logger_file_backend, "~> 0.0.11"},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false}

      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end

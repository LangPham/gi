defmodule Gi.MixProject do
  use Mix.Project

  @source_url "https://github.com/elixir-ecto/ecto"
  @version "0.1.0"

  def project do
    [
      app: :gi,
      version: @version,
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "Gi",
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
    ]
  end

  defp docs do
    [
      main: "Gi", # The main page in the docs
      source_url: "https://github.com/LangPham/gi",
      homepage_url: "https://github.com/LangPham/gi",
      logo: "guides/images/logo.svg",
      extras: [
        "README.md",
        "LICENSE"
      ],
      groups_for_modules: [
        # Gi,
        "Types": [
          Gi.Command,
          Gi.Image
        ]

      ]
    ]
  end

end

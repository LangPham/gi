defmodule Gi.MixProject do
  use Mix.Project

  @source_url "https://github.com/LangPham/gi"
  @version "0.2.0"

  def project do
    [
      app: :gi,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Hex
      description:
        "Gi is a library for manipulating Graphics Interfacing. Use utility mogrify, identify, ... of GraphicsMagick to resize, draw on base images....",
      package: package(),

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

  defp package do
    [
      files: ~w(lib mix.exs README* LICENSE .formatter.exs),
      maintainers: ["LangPham"],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.24", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      # The main page in the docs
      main: "Gi",
      source_url: @source_url,
      homepage_url: @source_url,
      logo: "guides/images/logo.svg",
      extras: [
        "README.md",
        "LICENSE"
      ],
      groups_for_modules: [
        Types: [
          Gi.Command,
          Gi.Image
        ]
      ]
    ]
  end
end

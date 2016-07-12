defmodule Bibtex.Mixfile do
  use Mix.Project

  def project do
    [app: :bibtex,
     version: "0.0.1",
     elixir: "~> 1.3",
     package: package,
     description: "A pure Elixir BibTeX parser inspired by Poison.",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  defp package do
    [# These are the default files included in the package
     name: :bibtex_elixir,
     files: ["lib", "mix.exs", "README*", "LICENSE*"],
     maintainers: ["Jack Weinbender"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/jackweinbender/bibtex-elixir"}]
  end

  defp deps do
    [{:mix_test_watch, "~> 0.2", only: :dev}]
  end
end

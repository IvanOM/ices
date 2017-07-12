# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ices,
  ecto_repos: [Ices.Repo]

# Configures the endpoint
config :ices, Ices.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "UWB63ksHFLoqcGlkJxtoepFUHaUx8G7J7B0Cg4lyKDWto0wDq0nPrBomzFXZ4cYe",
  render_errors: [view: Ices.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Ices.PubSub,
           adapter: Phoenix.PubSub.PG2]

 config :guardian, Guardian,
   allowed_algos: ["HS512"], # optional
   verify_module: Guardian.JWT,  # optional
   issuer: "Ices",
   ttl: { 2, :days },
   verify_issuer: true, # optional
   secret_key: System.get_env("GUARDIAN_SECRET") || "WGqGYQvleHFqV6p/TKUNY9WBBnr/U9ZUJa1jeKJYNdpJv6oa56yOL7D9ybmDR/F2",
   serializer: Ices.GuardianSerializer,
   hooks: GuardianDb

 config :guardian_db, GuardianDb,
   repo: Ices.Repo,
   sweep_interval: 120

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

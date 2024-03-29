# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :guardian_demo,
  ecto_repos: [GuardianDemo.Repo]

# Configures the endpoint
config :guardian_demo, GuardianDemoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "WrJO4vBmzJ7sJNnmRtB4tyGZbPOdbX2xprIvMvs42bSsNKFxQJbQZuk/IcQN7UuD",
  render_errors: [view: GuardianDemoWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: GuardianDemo.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Guardian
config :guardian_demo, GuardianDemo.Guardian,
  issuer: "guardian_demo",
  secret_key: "secretsecretsecret"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

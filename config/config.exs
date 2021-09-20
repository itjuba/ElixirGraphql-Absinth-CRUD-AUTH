# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :api_graphql,
  ecto_repos: [ApiGraphql.Repo]

# Configures the endpoint
config :api_graphql, ApiGraphqlWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bz1N1XfcAvNuhRR7FXatSO1iptvIi3f72QLOf/8zbhvtwuOrTe19UdgJeuENuPGI",
  render_errors: [view: ApiGraphqlWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: ApiGraphql.PubSub,
  live_view: [signing_salt: "yV+QlFQU"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :sefaz_metrics,
  ecto_repos: [SefazMetrics.Repo]

# Configures the endpoint
config :sefaz_metrics, SefazMetricsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "c4+FmeoHnn5rdUGXglo97aIDb/OpMSntGTh0d8YVjGa/b9pyxmNRCKMRFCw1/AP5",
  render_errors: [view: SefazMetricsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SefazMetrics.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]


# Configure Quantum 
config :sefaz_metrics, SefazMetrics.Scheduler,
  jobs: [
    # {"* * * * *", &SefazMetrics.Data.fetch_fact/0 },
    {"@hourly", { SefazMetrics.Data, :fetch_fact, []} },
  ]


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

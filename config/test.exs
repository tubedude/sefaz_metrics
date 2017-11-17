use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :sefaz_metrics, SefazMetricsWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :sefaz_metrics, SefazMetrics.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "sefaz_metrics_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

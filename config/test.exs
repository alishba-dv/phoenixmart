import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :api, Api.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "12BWjKCR3vEOClw6ZvJx3fWDRYg1BpVGJPvgzN/H9DQ5cexMvT1yFcATTG9qP0Yj",
  server: false

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :data, Data.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "data_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :phoenixmart, Phoenixmart.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "phoenixmart_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phoenixmart_web, PhoenixmartWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "BDize/tPQrCslM9oPFD6lOrHI2XNK+ej6tX/6BU591UwEVCF1nu5q8sjy8vViM1n",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# In test we don't send emails
config :phoenixmart, Phoenixmart.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

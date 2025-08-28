defmodule Phoenixmart.Repo do
  use Ecto.Repo,
    otp_app: :phoenixmart,
    adapter: Ecto.Adapters.Postgres
end

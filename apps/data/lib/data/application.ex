defmodule Data.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Data.Repo,
      {DNSCluster, query: Application.get_env(:data, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Data.PubSub}
      # Start a worker by calling: Data.Worker.start_link(arg)
      # {Data.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Data.Supervisor)
  end
end

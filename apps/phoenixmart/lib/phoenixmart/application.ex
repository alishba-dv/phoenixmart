defmodule Phoenixmart.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Phoenixmart.Repo,
      {DNSCluster, query: Application.get_env(:phoenixmart, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Phoenixmart.PubSub}
      # Start a worker by calling: Phoenixmart.Worker.start_link(arg)
      # {Phoenixmart.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Phoenixmart.Supervisor)
  end
end

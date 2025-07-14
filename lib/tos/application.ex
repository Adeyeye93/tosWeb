defmodule Tos.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TosWeb.Telemetry,
      Tos.Repo,
      {DNSCluster, query: Application.get_env(:tos, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Tos.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Tos.Finch},
      # Start a worker by calling: Tos.Worker.start_link(arg)
      # {Tos.Worker, arg},
      # Start to serve requests, typically the last entry
      TosWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tos.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TosWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

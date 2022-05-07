defmodule Pubsublive.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Pubsublive.MyBroadway, []},
      # Start the Ecto repository
      Pubsublive.Repo,
      # Start the Telemetry supervisor
      PubsubliveWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Pubsublive.PubSub},
      # Start the Endpoint (http/https)
      PubsubliveWeb.Endpoint
      # Start a worker by calling: Pubsublive.Worker.start_link(arg)
      # {Pubsublive.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pubsublive.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PubsubliveWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

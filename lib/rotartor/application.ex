defmodule Rotartor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        # Start the Telemetry supervisor
        RotartorWeb.Telemetry,
        # Start the PubSub system
        {Phoenix.PubSub, name: Rotartor.PubSub},
        # Start the Endpoint (http/https)
        RotartorWeb.Endpoint
        # Start a worker by calling: Rotartor.Worker.start_link(arg)
        # {Rotartor.Worker, arg}
      ] ++ children(target())

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Rotartor.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Children that only run on the host
      # Starts a worker by calling: Rotartor.Worker.start_link(arg)
      # {Rotartor.Worker, arg},
    ]
  end

  def children(_target) do
    [
      # Children for all targets except host
      # Starts a worker by calling: Rotartor.Worker.start_link(arg)
      # {Rotartor.Worker, arg},
    ]
  end

  def target() do
    Application.get_env(:rotartor, :target)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RotartorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

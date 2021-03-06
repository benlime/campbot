defmodule Campbot.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(CampbotWeb.Endpoint, []),
      Campbot.Bot.Subscribers,
    ]

    ## add crawler jobs to child specs
    children = children ++ Campbot.Crawler.ChildSpecs.all()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Campbot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CampbotWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

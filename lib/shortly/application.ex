defmodule Shortly.Application do
  @moduledoc false
  use Application
  require Logger

  def start(_type, _args) do
    children = [
      # The port should be specified in an env file.
      {Plug.Cowboy, scheme: :http, plug: Shortly.Router, options: [port: 8080]},
      {Shortly.UrlShortener, name: Shortly.UrlShortener}
    ]

    opts = [strategy: :one_for_one, name: Shortly.Supervisor]

    Logger.info("Starting application on http://localhost:8080")

    Supervisor.start_link(children, opts)
  end
end

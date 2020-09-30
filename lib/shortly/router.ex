defmodule Shortly.Router do
  use Plug.Router

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["text/*"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "I'm up")
  end

  post "/encode" do
    %{"url" => url} = conn.body_params

    case validate_url(url) do
      {:ok, url} ->
        {:ok, url} = Shortly.UrlShortener.shorten(Shortly.UrlShortener, url)
        # TODO: This is confusing, we're not returning a url we're returning a key
        {:ok, json} = Jason.encode(%{"url" => "http://short.ly/" <> url})
        send_resp(conn, 200, json)

      {:error, msg} ->
        {:ok, json} = Jason.encode(%{"error" => msg})
        send_resp(conn, 400, json)
    end
  end

  post "/decode" do
    %{"url" => url} = conn.body_params

    case validate_url(url) do
      {:ok, url} ->
        %{path: path} = URI.parse(url)
        {:ok, url} = Shortly.UrlShortener.get(Shortly.UrlShortener, String.trim_leading(path, "/"))
        {:ok, json} = Jason.encode(%{"url" => url})
        send_resp(conn, 200, json)

      {:error, msg} ->
        {:ok, json} = Jason.encode(%{"error" => msg})
        send_resp(conn, 400, json)
    end
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end

  defp validate_url(url) do
    uri = URI.parse(url)

    if uri.scheme != nil && uri.host =~ "." do
      {:ok, url}
    else
      {:error, "Invalid url"}
    end
  end
end

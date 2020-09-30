defmodule Shortly.UrlShortener do
  use GenServer

  # TODO: I don't think I need this client method either.
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def shorten(server, url) do
    # TODO: we don't need to pass a GenServer name.
    # There should only be one GenServer.
    GenServer.call(server, {:shorten, url})
  end

  def get(server, url) do
    GenServer.call(server, {:get, url})
  end

  @impl true
  def init(:ok) do
    encoded_urls = %{}
    inverse_encoded_urls = %{}
    {:ok, {encoded_urls, inverse_encoded_urls}}
  end

  @impl true
  def handle_call({:shorten, url}, _from, state) do
    {encoded_urls, inverse_encoded_urls} = state
    new_key = gen_key()
    # TODO:  Still need to handle collisions
    case Map.fetch(inverse_encoded_urls, url) do
      {:ok, key} ->
        {:reply, {:ok, key}, state}

      :error ->
        {:reply, {:ok, new_key},
         {Map.put(encoded_urls, new_key, url), Map.put(inverse_encoded_urls, url, new_key)}}
    end
  end

  @impl true
  def handle_call({:get, url}, _from, state) do
    {encoded_urls, _} = state
    # TODO: URL is misleading, it's just a key
    {:reply, Map.fetch(encoded_urls, url), state}
  end

  defp gen_key() do
    key_seq = Enum.to_list(?a..?z) ++ Enum.to_list(?A..?Z) ++ Enum.to_list(?0..?9)
    key = Enum.map(1..8, fn _ -> Enum.random(key_seq) end)
    to_string(key)
  end
end

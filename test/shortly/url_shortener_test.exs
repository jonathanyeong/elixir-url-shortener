defmodule Shortly.UrlShortenerTest do
  use ExUnit.Case, async: true

  setup do
    shortener = start_supervised!(Shortly.UrlShortener)
    %{shortener: shortener}
  end

  test "encodes a url and returns the original url", %{shortener: shortener} do
    assert {:ok, url} = Shortly.UrlShortener.shorten(shortener, "https://google.com")
    assert {:ok, url} = Shortly.UrlShortener.get(shortener, url)
  end

  test "if given duplicate url, it will return the same encoding", %{shortener: shortener} do
    {:ok, url1} = Shortly.UrlShortener.shorten(shortener, "https://google.com")
    {:ok, url2} = Shortly.UrlShortener.shorten(shortener, "https://google.com")
    assert url1 == url2
  end
end

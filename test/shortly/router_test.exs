defmodule Shortly.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts Shortly.Router.init([])

  # ========
  # Happy path
  # The url is valid
  # ========

  test "with a valid url returns a shortened url" do
    conn =
      conn(:post, "/encode", Jason.encode!(%{"url" => "https://www.google.com"}))
      |> put_req_header("content-type", "application/json")

    conn = Shortly.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    %{"url" => url} = Jason.decode!(conn.resp_body)
    assert String.starts_with?(url, "http://short.ly/")
    # Assert that a keys exists
  end

  test "with a valid url returns a full url" do
    conn1 =
      conn(
        :post,
        "/encode",
        Jason.encode!(%{
          "url" =>
            "https://www.change.org/p/change-engineering-oh-wow-i-wish-this-petition-had-a-some-kind-of-link-that-was-shorter-than-the-default-one"
        })
      )
      |> put_req_header("content-type", "application/json")

    conn1 = Shortly.Router.call(conn1, @opts)
    %{"url" => encoded_url} = Jason.decode!(conn1.resp_body)

    conn =
      conn(:post, "/decode", Jason.encode!(%{"url" => encoded_url}))
      |> put_req_header("content-type", "application/json")

    conn = Shortly.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    %{"url" => url} = Jason.decode!(conn.resp_body)

    assert url ==
             "https://www.change.org/p/change-engineering-oh-wow-i-wish-this-petition-had-a-some-kind-of-link-that-was-shorter-than-the-default-one"
  end

  # ========
  # Sad path
  # The url is invalid
  # ========

  test "hitting encode with an invalid url returns a 400" do
    conn1 =
      conn(:post, "/encode", Jason.encode!(%{"url" => "www.google.com"}))
      |> put_req_header("content-type", "application/json")

    conn1 = Shortly.Router.call(conn1, @opts)

    assert conn1.status == 400

    conn2 =
      conn(:post, "/encode", Jason.encode!(%{"url" => "http://google"}))
      |> put_req_header("content-type", "application/json")

    conn2 = Shortly.Router.call(conn2, @opts)

    assert conn2.status == 400
  end

  test "hitting decode with an invalid url returns a 400" do
    conn1 =
      conn(:post, "/decode", Jason.encode!(%{"url" => "www.google.com"}))
      |> put_req_header("content-type", "application/json")

    conn1 = Shortly.Router.call(conn1, @opts)

    assert conn1.status == 400

    conn2 =
      conn(:post, "/decode", Jason.encode!(%{"url" => "http://google"}))
      |> put_req_header("content-type", "application/json")

    conn2 = Shortly.Router.call(conn2, @opts)

    assert conn2.status == 400
  end
end

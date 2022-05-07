defmodule PubsubliveWeb.PageController do
  use PubsubliveWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

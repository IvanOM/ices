defmodule Ices.PageController do
  use Ices.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

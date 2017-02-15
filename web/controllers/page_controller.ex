defmodule FrontElmBackPhoenix.PageController do
  use FrontElmBackPhoenix.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

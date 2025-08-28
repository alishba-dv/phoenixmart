defmodule PhoenixmartWeb.PageController do
  use PhoenixmartWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end

defmodule Api.PageController do
  use Api, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end

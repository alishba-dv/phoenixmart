defmodule Api.AuthErrorHandler do
  import Plug.Conn

  def auth_error(conn, {type, reason}, _opts) do
    # Always safe — convert everything to a string with inspect/1
    body = %{
      message: "Authentication failed",
      type: inspect(type),
      reason: inspect(reason)   # never crashes
    }

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, Jason.encode!(body))
  end
end

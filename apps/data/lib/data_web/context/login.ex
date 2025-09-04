defmodule Data.Context.Login do


  alias Data.Repo
  import Ecto.Query
  alias Data.Schema.User



  def login(params) do
    email=params["email"]
    password=params["password"]

    user =
      User
      |> where([u], u.email == ^email)
      |>preload(:roles)
      |> Repo.one()


    case Bcrypt.verify_pass(password, user.password) do
      true ->
        # Passwords match, proceed with login
        IO.puts("Passwords match!")
      false ->
        # Passwords do not match, show an error
        IO.puts("Invalid password.")
    end


      case user do
      nil-> {:error,%{message: "No user found"}}
      user -> {:ok,user}
    end
  end
end
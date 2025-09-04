defmodule Data.Context.ViewUsers do


  alias Data.Repo
  alias Data.Schema.User
  import Ecto.Query

  def viewusers() do

    user =User|>preload(:roles) |> Repo.all()

    case user  do

      nil -> {:error,%{message: "No record found"}}

      users -> {:ok,users}
      _ ->{:error,%{message: "Error occurred"}}
    end

  end
end
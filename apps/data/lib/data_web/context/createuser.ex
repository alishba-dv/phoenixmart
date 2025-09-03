defmodule Data.Context.CreateUser do
  import Ecto.Query
  alias Ecto.Changeset


  alias Data.Repo
  alias Data.Schema.User
  alias Data.Schema.Role
  import Ecto.Query

  def createuser(params) do

    role_ids =
      case Map.get(params, "role") do
        nil -> []
        ids when is_list(ids) -> Enum.map(ids, &String.to_integer/1)
        id when is_binary(id) -> [String.to_integer(id)]
      end
    roles = Repo.all(from r in Role, where: r.id in ^role_ids)
    IO.inspect(roles, label: "ROLES TO ASSOCIATE")  # DEBUG



    user=
      %User{}
      |>User.changeset(params)
      |> Ecto.Changeset.put_assoc(:roles, roles)

    case Repo.insert(user) do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> {:error, changeset}
    end
  end

end
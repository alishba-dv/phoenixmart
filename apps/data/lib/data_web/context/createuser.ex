defmodule Data.Context.CreateUser do
  import Ecto.Query
#  alias Ecto.Changeset


  alias Data.Repo
  alias Data.Schema.User
  alias Data.Schema.Role
  import Ecto.Query

  def createuser(params) do





               role_ids =
                 params["role"]
                 |> List.wrap()                     # always turns it into a list
                 |> Enum.map(&String.to_integer/1)

    roles = Repo.all(from r in Role, where: r.id in ^role_ids)
    IO.inspect(roles, label: "ROLES TO ASSOCIATE")  # DEBUG



    user=
      %User{}
      |>User.changeset(params)
      |> Ecto.Changeset.put_assoc(:roles, roles)


     password= params["password"]

     hashedpassword=Bcrypt.hash_pwd_salt(password)

               changeset =
                 %User{}
                 |> User.changeset(%{
                   "email" => params["email"],
                   "name" => params["name"],
                   "password" => hashedpassword
                 })|>  Ecto.Changeset.put_assoc(:roles, roles)







               case Repo.insert(changeset) do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> {:error, changeset}
    end
  end

end
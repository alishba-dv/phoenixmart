defmodule Api.UserController do

  alias Data.Schema.User
  use PhoenixSwagger
  alias Data.Context.Login
  alias Data.Context.CreateUser
  alias Api.Auth.Guardian
  Data.Context.ViewUsers


  use Api, :controller
#  ---------------------Swagger paths----------------------------


  swagger_path :createuser do
    security [%{Bearer: []}]


    post("/api/user")

    summary("Create a user")
    description("A new user will be created")
    produces "application/json"
    consumes "application/json"

    parameters do
      user :body, Schema.ref(:users), "User logged in  successfully",required: true

    end


    response 200, "Success",Schema.ref(:users)
    response 404, "Bad request"


  end


  swagger_path :login do
    post("/api/login")

    summary("Logs in a user")
    description("A user will be logged in")
    produces "application/json"
    consumes "application/json"

    parameters do
      user :body, Schema.ref(:login), "User logged in  successfully",required: true

    end


    response 200, "Success",Schema.ref(:login)
    response 404, "Bad request"


  end

  swagger_path :viewusers do
    get("/api/users")
    security [%{Bearer: []}]
    summary("View all users")
    description("View all users")
    produces "application/json"




    response 200, "Success",Schema.ref(:viewusers)
    response 404, "Bad request"


  end





  #----------------------------Swagger Schemas-------------------------------

def swagger_definitions do
  %{
  users: swagger_schema do
    title "user"
    description "A user record"
    properties do
      name :string, "name", required: true
      email :string, "email", required: true
      password :string, "password", required: true
      role :string, "role", required: true
    end

    example %{

      name: "tester",
      email: "tester@gmail.com",
      password: "12345#",
      role: "1"
    }
  end,
    login: swagger_schema do

      title "user"
      description "log in a user"
      properties do
        email :string, "email", required: true
        password :string, "password", required: true
      end

      example %{

        email: "tester@gmail.com",
        password: "12345#",

      }
    end,
    viewusers: swagger_schema do

      title "user"
      description "View a  user"
      properties do
        email :string, "email", required: true
        password :string, "password", required: true
        role_id :string, "Role ID", required: true
        role_name :string, "Role Name", required: true
      end
      example %{
      email: "tester@gmail.com",
      name: "tester",
      role_id: "1",
      role_name: "Admin"
               }


    end
  }
end


#----------------------------------------------------------------------

  def createuser(conn,%{"name"=>name,"email"=>email,"password"=>password,"role"=>role}) do


    params=%{"name"=>name,"email"=>email,"password"=>password,"role"=>role}

    case Data.Context.CreateUser.createuser(params) do

      {:ok,user} ->
#        {:ok,token,claims} =Api.Auth.Guardian.encode_and_sign(user)

        json(conn,%{message: "User created successfullly"})

       {:error, changeset} ->
  errors =
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)

  json(conn, %{errors: errors})

    end


    end



  def login(conn, %{"email" => email, "password" => password}) do
    case Login.login(%{"email" => email, "password" => password}) do
      {:ok, user} ->
        {:ok, token, _claims} = Api.Auth.Guardian.encode_and_sign(user)
        json(conn, %{Access_token: token, id: user.id, name: user.name, email: user.email,   roles: Enum.map(user.roles, fn role -> %{id: role.id, name: role.name} end)
        })

      {:error, message} ->
        json(conn, %{message: message})
    end
  end


  def viewusers(conn, _params) do
    case Data.Context.ViewUsers.viewusers() do

      {:ok,users}->
    user_maps =
      Enum.map(users, fn user ->
        %{
          id: user.id,
          name: user.name,
          email: user.email,
          roles:
            Enum.map(
              user.roles, fn role ->
            %{id: role.id,
              name: role.name
            }
          end)
        }
      end)

    json(conn, %{
      message: "Users fetched successfully",
      users: user_maps
    })


    {:error,message} -> json(conn,%{message: message})
  end

  end

end




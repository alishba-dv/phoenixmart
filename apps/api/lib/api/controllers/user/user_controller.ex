defmodule Api.UserController do

  alias Data.Schema.User
  use PhoenixSwagger
  alias Data.Context.CreateUser
  alias Api.Auth.Guardian
  use Api, :controller
#  ---------------------Swagger paths----------------------------


swagger_path :createuser do
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

    end



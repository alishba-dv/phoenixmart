defmodule Api.UserController do

  alias Data.Schema.User
  use PhoenixSwagger
  alias Data.Context.Login
  alias Data.Context.CreateUser
  alias Api.Auth.Guardian
  alias Data.Context.ViewUsers

  alias Data.Repo
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


    parameters do
      name(:query,:string,"Name to filter",required: false)
      email(:query,:string,"Email to filter",required: false)
      role(:query,:string,"Role to filter",required: false,enum: ["1","2","3"])
      sort(:query,:string,"Sort the results",required: false,enum: ["Ascending","Descending"])
      page(:query,:string,"Page number to show",required: false)
      page_size(:query,:string,"Total Entries in a page",required: false)
      end



    response 200, "Success",Schema.ref(:viewusers)
    response 404, "Bad request"


  end

  swagger_path :viewroles do
    get("/api/roles")
    security [%{Bearer: []}]
    summary("View all Roles")
    description("View all Roles")
    produces "application/json"

    response 200, "Success",Schema.ref(:viewroles)
    response 404, "Bad request"


  end
  swagger_path :profile do
    get("/api/profile")
    security [%{Bearer: []}]
    summary("View profile
")
    description("A user can view profile")
    produces "application/json"

    response 200, "Success",Schema.ref(:profile)
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


    end,

    profile: swagger_schema do

      title "Profile"
      description "View a  user profile"

      example %{
        email: "tester@gmail.com",
        name: "tester",
       roles:
        %{
         role_id: "1",
        role_name: "Admin",

        role_id: "3",
        role_name: "Manager",

          }
      }


    end,


    viewroles: swagger_schema do
      title "Roles"
      description "View all roles"

      example %{

        id: "1",
        name: "Admin"
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


  def viewusers(conn,params) do
  name=params["name"]
  email=params["email"]
  role=params["role"]
  page=params["page"]
  pagesize=params["pagesize"]
  order=params["order"]

  page= Data.Context.ViewUsers.viewusers(name,email,order,role,page,pagesize)

if page.total_entries==0 do

  json(conn,%{message: "no record fetched"})
end
    user_maps =
      Enum.map(page.entries, fn user ->
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


  end


  def viewroles(conn,_params) do
    page=Data.Context.ViewRoles.viewroles()


    if page.total_entries==0 do
      json(conn,%{message: "No role found"})
    end

    roles=page.entries

    json(conn,%{
    message: "Roles fetched successfully",
    status: "Success",
     Roles:

    Enum.map(roles,fn role->
         %{
           id: role.id,
          name: role.name,
          users: Enum.map(role.users, fn user ->
          %{
            name: user.name,
          email: user.email
          }end) ,





    } end ),

      page_size: page.page_size,
      page: page.page_number,
      total_entries: page.total_entries


}
      )


end


def profile(conn,_params) do
      user=Guardian.Plug.current_resource(conn)
     user= Repo.preload(user,:roles)

    json(conn,%{message: "Profile fetched successfuully",
                       user: %{
id: user.id,
name: user.name,
email: user.email,
                       roles: Enum.map(user.roles, fn r -> %{
                      id:  r.id,
                       name: r.name
                                                           } end)
                          }})

                          end



end




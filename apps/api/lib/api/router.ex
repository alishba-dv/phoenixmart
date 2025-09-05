defmodule Api.Router do
  use Api, :router
  use PhoenixSwagger
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {Api.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end
  def swagger_info do
    %{
      info: %{title: "PhoenixMart  Rest API", version: "1.0"},
      basePath: "/",
      schemes: ["http","https"],
      securityDefinitions: %{
        Bearer: %{
          type: "apiKey",
          name: "Authorization",
          in: "header",
          description: "JWT auth using Bearer scheme. Example: 'Bearer <token>'"
        }
      }
    }
  end
  pipeline :api do
    plug :accepts, ["json"]
  end


  pipeline :auth do
    plug Api.Auth.Pipeline
  end

#  scope "/", Api do
#    pipe_through :browser
#
#    get "/", PageController, :home
#  end

  # Other scopes may use custom stacks.
#   scope "/api", Api do
#     pipe_through :api
#
#  end

  scope "/" do
    # Swagger UI will be at /swagger
    forward "/swagger", PhoenixSwagger.Plug.SwaggerUI,
            otp_app: :api,
            swagger_file: "swagger.json"
  end

  scope "/api" do
    pipe_through [:api]

#    post "/user", Api.UserController, :createuser
    post "/login",Api.UserController, :login
  end


  scope "/api" do
    pipe_through [:api,:auth]

    post "/user", Api.UserController, :createuser
    post "/login",Api.UserController, :login
    get "/users", Api.UserController, :viewusers
    get "/roles", Api.UserController, :viewroles
    get "/profile",Api.UserController, :profile
    post "/product",Api.ProductController, :createproduct
    post "/category",Api.CategoryController,:createcategory
  end



  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:api, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: Api.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

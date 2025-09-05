defmodule Api.CategoryController do

  alias Data.Context.CreateCategory
  use Api, :controller
  use PhoenixSwagger


  swagger_path :createcategory do
    security  [%{Bearer: []}]
    post("/api/category")
    description("Add a new category")
    summary("Add a new category in database")
    produces "application/json"
    consumes "application/json"
    parameters do
      category :body,Schema.ref(:createcategory),"Category created successfully",required: true
    end

    response 200, "Category created successfully",Schema.ref(:createcategory)
    response 404, "Bad request"

  end



  def swagger_definitions do %{

  createcategory: swagger_schema do
    title "Create Category"
    description "Create a new category"
    properties do
      name :string,"Category Name",required: true
    end
    example %{
    name: "category#1"
    }

  end

                             } end

  def createcategory(conn,params) do
   case  CreateCategory.createcategory(params)  do
     {:ok,_category} -> json(conn,%{

            status: "Success",
            message: "Category added successfully",

     })

     {:error,changeset} -> error= Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
       Enum.reduce(opts, msg, fn {key, value}, acc ->
         String.replace(acc, "%{#{key}}", to_string(value))
       end)
     end)
     json(conn,%{status: "error",message: error})
   end
  end
  end
defmodule Api.ProductController do
  alias Data.Repo
  use Api, :controller
  use PhoenixSwagger
  alias Data.Context.CreateProduct


  swagger_path :createproduct do
    security [%{Bearer: []}]
    post("/api/product")
    description("To create a product in database")
    summary("Create product")
    produces "application/json"
    consumes "application/json"


    parameters do
     product :body,Schema.ref(:createproduct),"Product Created successfully",required: true
    end

    response 200, "Product Created successfully", Schema.ref(:createproduct)
    response 404, "Bad Request"

  end



  def swagger_definitions do %{


  createproduct: swagger_schema do

    title ("Create a new product")
    description("Create a new product in database")

    example %{

     name: "dummy product",
     description: "This is a dummy product",
     stock: 20,
     price_in_dollars: 100,
     category_id: "1"

    }


    end

                             }end






  def createproduct(conn,params) do
   case  Data.Context.CreateProduct.createproduct(params) do

     {:ok,product} ->  json(conn, %{
          status: "Success",
          message: "Product Added successfully",

                    name: product.name,
                    description: product.description,
                    stock: product.stock,
                    price_in_dollars: product.price,
                    category_id: product.category_id,



                            })

       {:error,changeset} ->
        error=
        Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
          Enum.reduce(opts, msg, fn {key, value}, acc ->
            String.replace(acc, "%{#{key}}", to_string(value))
          end)
        end)
            json(conn,%{message: error})


        {:ServerError,message} ->
          json(conn,%{message: message})
   end


  end
end
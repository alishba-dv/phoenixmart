defmodule Data.Context.CreateProduct do

  alias Data.Product
  alias Data.Schema.Category
  alias Data.Repo
  import Ecto.Query


  def createproduct(params) do

    category_id=params["category_id"]
    name=params["name"]
    description=params["description"]
    price=params["price"]
    stock=params["stock"]


    changeset=%Product{} |> Product.changeset(%{name: name,description: description,price: price, stock: stock,category_id: category_id})


    product = Repo.insert(changeset)
#              |>preload(:categories)
    case product do
      {:ok,product} -> {:ok,product}
      {:error,changeset} -> {:error,changeset}
      _ -> {:ServerError,%{message: "Failed to fetch"}}
     end

end
end
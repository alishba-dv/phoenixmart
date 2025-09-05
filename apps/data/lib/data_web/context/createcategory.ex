defmodule Data.Context.CreateCategory do

  alias Data.Repo
  alias Data.Category

  def createcategory(params) do

    changeset=%Category{} |> Category.changeset(params)

   case  Repo.insert(changeset) do
     {:ok,_category} -> {:ok,_category}

     {:error,changeset} ->  {:error,changeset}
   end

  end
  end
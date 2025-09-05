defmodule Data.Context.ViewRoles do


  alias Data.Repo
  alias Data.Schema.Role
  import Ecto.Query


  def viewroles()do

query=from r in Role, preload: [:users]
Repo.paginate(query)

  end

end
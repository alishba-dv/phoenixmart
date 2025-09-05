defmodule Data.Context.ViewUsers do


  alias Data.Repo
  alias Data.Schema.User
  import Ecto.Query
  alias Data.Schema.Role



  def viewusers(name\\nil,email\\nil,order\\nil,role\\nil,page\\nil,page_size\\nil)  do

   filter=dynamic([u],true)

   filter = if name, do:  dynamic([u], ^filter and  u.name == ^ name ), else: filter
   filter = if email, do:  dynamic([u], ^filter and  u.email == ^ email ), else: filter



   case order do

     "Ascending" -> from u in User, order_by: [asc: u.name]
     "Descending" -> from u in User, order_by: [desc: u.name]
     _ -> filter
   end


   query= from u in User, where: ^filter, preload: [:roles]


   Repo.paginate(query,page: page, page_size: page_size)


  end
end
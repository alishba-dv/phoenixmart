defmodule Data.Context.LoginById do

  alias Data.Repo
  import Ecto.Query
  alias Data.Schema.User


  def loginbyid(id) do


   user= Repo.get(User,id)

   if user do
     {:ok,user}
     else
     {:error,%{message: "User not found"}}
   end


    end
end
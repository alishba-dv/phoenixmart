defmodule Api.Auth.Guardian do
  alias Data.Context.Login



  def subject_for_token(claims,user)do
    {:ok,to_string(user.id)}
  end

  def resource_from_claims(%{"sub"=>id}) do

  case  Login.login_by_id(id) do

    nil -> {:error,"No resource with this id found"}
    user -> {:ok,user}

  end





  end
end
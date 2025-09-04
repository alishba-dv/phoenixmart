defmodule Api.Auth.Guardian do
#  alias Data.Context.LoginById

  alias Data.Schema.User
  alias Data.Repo


  use Guardian, otp_app: :api


  def subject_for_token(%{id: id}, _claims) do
    {:ok,to_string(id)}
  end


  def subject_for_token(_, _) do
    {:error, :invalid_resource}
  end




  def resource_from_claims(%{"sub"=>id}) do
    id = String.to_integer(id)  # convert token sub back to integer
    case Repo.get(Data.Schema.User, id) do
      nil ->
        IO.puts("No user found with ID #{id}")
        {:error, :no_resource_found}
      user -> {:ok, user}
    end
  end



  end

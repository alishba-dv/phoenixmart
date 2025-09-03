defmodule Data.Schema.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do

    field :name, :string

    many_to_many :users, Data.Schema.User, join_through: "user_roles"

    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end

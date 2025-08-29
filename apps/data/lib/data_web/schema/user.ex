defmodule Data.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string

    has_many :orders, Data.Order   ###a user can have many orders  and order must belong to a user
#
    many_to_many :roles, Data.Role,join_through: "user_roles" ,on_replace: :delete   ###a user can have many roles and a role can belong to many users and as user roles table dont have user id stored so we will hae a join through table with cascade delete


    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |>unique_constraint(:email,message: "Email must be unique")
    |>validate_length(:password, min: 6,message: "Password must be 6 character long")
    |> validate_format(:email, ~r/^[^@\s]+@[^@\s]+\.[^@\s]+$/, message: "is not a valid email format")
    |>validate_format(:password, ~r/[!@#$%^&*]/,message: "Password must contain at least one special character")
  end
end

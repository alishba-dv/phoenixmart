defmodule Data.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :price, :integer
    field :quantity, :integer
    field :status, :string
    field :total_price, :integer
#    field :user_id, :integer

    many_to_many :products, Data.Product, join_through: Data.OrderItem, on_replace: :delete
    has_many :orderitems, Data.OrderItem
    belongs_to :user, Data.User

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:user_id, :status, :total_price, :quantity, :price])
    |> validate_required([:user_id, :status, :total_price, :quantity, :price])
    |> validate_number(:total_price, greater_than_or_equal_to: 0, message: "Total Price of product must be greater than or equal to  0")
    |> validate_number(:quantity, greater_than_or_equal_to: 0,message: "Quantity of product must be greater than or equal to 0")
    |> validate_number(:price, greater_than_or_equal_to: 0,message: "Price must be greater than or equal to 0")

  end
end

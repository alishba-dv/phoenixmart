defmodule Data.OrderItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orderitems" do
    field :order_id, :integer
    field :price, :integer
    field :product_id, :integer
    field :quantity, :integer

   belongs_to :orders,Data.Order
   belongs_to :products,Data.Product

    timestamps()
  end

  @doc false
  def changeset(order_item, attrs) do
    order_item
    |> cast(attrs, [:order_id, :product_id, :quantity, :price])
    |> validate_required([:order_id, :product_id, :quantity, :price])
    |>validate_number(:price, greater_than_or_equal_to: 0, message: "Order price must be greater than or equal to 0")
    |>validate_number(:quatity, greater_than_or_equal_to: 0, message: "Quantity price must be greater than or equal to 0")

  end
end

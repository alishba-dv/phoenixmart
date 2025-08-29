defmodule Data.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :category_id, :integer
    field :description, :string
    field :name, :string
    field :price, :integer
    field :stock, :integer

    belongs_to :categories, Data.Category
    many_to_many :orders, Data.Order, join_through: Data.OrderItem, on_replace: :delete
    has_many :order_items, Data.OrderItem

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :price, :stock, :category_id])
    |> validate_required([:name, :description, :price, :stock, :category_id])
    |>validate_number(:price, greater_than: 0, message: "Price of product must be greater than 0 ")
    |>validate_number(:stock, greater_than_or_equal_to: 0,message: "Stock must be greater than or equal to  0 ")
    |>unique_constraint(:name,message: "Name of product must be unique")

  end
end

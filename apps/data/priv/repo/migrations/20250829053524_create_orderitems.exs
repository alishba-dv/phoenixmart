defmodule Data.Repo.Migrations.CreateOrderitems do
  use Ecto.Migration

  def change do
    create table(:orderitems) do
      add :order_id, :integer
      add :product_id, :integer
      add :quantity, :integer
      add :price, :integer

      timestamps()
    end

    create unique_index(:orderitems,[:order_id,])
  end
end

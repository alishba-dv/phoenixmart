defmodule Data.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
#      add :user_id, :integer
      add :status, :string
      add :total_price, :integer
      add :quantity, :integer
      add :price, :integer

      timestamps()
    end


  end
end

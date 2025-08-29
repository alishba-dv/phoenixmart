defmodule Data.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :description, :string
      add :price, :integer
      add :stock, :integer
      add :category_id, :integer

      timestamps()

    end
    create unique_index(:products,[:name])


end
end

defmodule Backend.Repo.Migrations.CreateReviews do
  use Ecto.Migration

  def change do
    create table(:reviews) do
      add :rating, :integer
      add :comment, :string
      add :place_id, references(:places, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:reviews, [:place_id])
    create index(:reviews, [:user_id])
  end
end

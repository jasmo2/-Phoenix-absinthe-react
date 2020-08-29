defmodule Backend.Repo.Migrations.CreateBookings do
  use Ecto.Migration

  def change do
    create table(:bookings) do
      add :start_date, :date, null: false
      add :end_date, :date, null: false
      add :state, :string, null: false
      add :total_price, :decimal, null: false
      add :place_id, references(:places, on_delete: :nilify_all), null: false
      add :user_id, references(:users, on_delete: :nilify_all), null: false

      timestamps()
    end

    create index(:bookings, [:place_id, :user_id])
  end
end

defmodule Backend.Vacation.Place do
  use Ecto.Schema
  import Ecto.Changeset

  schema "places" do
    field :description, :string
    field :image, :string
    field :image_thumbnail, :string
    field :location, :string
    field :max_guest, :integer
    field :name, :string
    field :pet_friendly, :boolean, default: false
    field :pool, :boolean, default: false
    field :price_per_night, :decimal
    field :slug, :string
    field :wifi, :boolean, default: false

    has_many(:bookings, Backend.Vacation.Booking)
    has_many(:reviews, Backend.Vacation.Review)

    timestamps()
  end

  @doc false
  def changeset(place, attrs) do
    require_fields = [
      :description,
      :image,
      :image_thumbnail,
      :location,
      :name,
      :price_per_night,
      :slug
    ]

    optional_fields = [
      :max_guest,
      :pet_friendly,
      :pool,
      :wifi
    ]

    place
    |> cast(attrs, require_fields ++ optional_fields)
    |> validate_required(require_fields)
    |> unique_constraint(:name)
    |> unique_constraint(:slug)
  end
end

defmodule Backend.TestHelpers do
  alias Backend.Repo

  alias Backend.Vacation.{Place}

  def place_fixture(attrs \\ %{}) do
    name = "place-#{System.unique_integer([:positive])}"

    attrs =
      Enum.into(attrs, %{
        name: attrs[:name] || name,
        slug: attrs[:slug] || name,
        description: "some description",
        location: "some location",
        price_per_night: Decimal.from_float(120.00),
        image: "some-image",
        image_thumbnail: "some-image-thumbnail"
      })

    {:ok, place} =
      %Place{}
      |> Place.changeset(attrs)
      |> Repo.insert!()

    place
  end
end

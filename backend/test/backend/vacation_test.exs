defmodule Backend.VacationTest do
  use Backend.DataCase, async: false

  alias Backend.Vacation
  alias Backend.Vacation.{Review, Booking}

  describe "get place by slug" do
    test "returns the place with the given slug" do
      place = place_fixture()
      vacation_place = Vacation.get_place_by_slug!(place.slug)
      assert vacation_place == place
    end
  end

  describe "list_places/1" do
    test "return all places by default" do
      places = places_fixture

      vacation_places = Vacation.list_places()
      assert length(vacation_places) == length(places)
    end

    test "return limited amount of places" do
      # places fixtures add places to test_db
      places_fixture

      criteria = %{limit: 1}
      vacation_places = Vacation.list_places(criteria)

      assert length(vacation_places) == 1
    end

    test "returns limited amount of places and ordered them" do
      places_fixture

      criteria = %{limit: 2, order: :desc}

      vacation_places = Vacation.list_places(criteria)

      # assert vacation_places |> Enum.map(fn place -> place.name end) == ["Place 3", "Place 2"]
      # The as the below one
      assert Enum.map(vacation_places, & &1.name) == ["Place 3", "Place 2"]
    end

    test "return places filtered by matching name" do
      places_fixture

      criteria = %{filter: %{matching: "1"}}

      vacation_places = Vacation.list_places(criteria)

      assert vacation_places |> Enum.map(& &1.name) == ["Place 1"]
    end

    test "returns places filtered by pet_friendly" do
      places_fixture

      criteria = %{filter: %{pet_friendly: true}, order: :desc}

      vacation_places = Vacation.list_places(criteria)

      assert vacation_places |> Enum.map(& &1.name) == ["Place 3", "Place 2"]
    end

    test "returns places filtered by pool" do
      places_fixture

      criteria = %{filter: %{pool: true}, order: :desc}

      vacation_places = Vacation.list_places(criteria)

      assert vacation_places |> Enum.map(& &1.name) == ["Place 2"]
    end
  end
end

defmodule Backend.VacationTest do
  use Backend.DataCase, async: true

  alias Backend.Vacation
  alias Backend.Vacation.{Review, Booking}

  describe "get place by slug" do
    test "returns the place with the given slug" do
      place = place_fixture()
      assert Vacation.get_place_by_slug!(place.slug) == place
    end
  end

  describe "list_places/1" do
    test "return all places by default" do
      # places = places_fixtures
      places = []

      vacation_places = Vacation.list_places([])
      assert length(vacation_places) == length(places)
    end
  end
end

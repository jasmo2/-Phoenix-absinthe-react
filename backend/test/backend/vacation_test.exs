defmodule Backend.VacationTest do
  use Backend.DataCase, async: true

  alias Backend.Vacation
  alias Backend.Vacation.{Review, Booking}

  describe "get place by slug" do
    test "returns the place with the given slug" do
      place = place_fixture()
      vacation_place = Vacation.get_place_by_slug!(place.slug)
      assert IO.inspect(vacation_place) == place
    end
  end

  @tag :skip
  describe "list_places/1" do
    test "return all places by default" do
      # places = places_fixtures
      places = []

      vacation_places = Vacation.list_places([])
      assert length(vacation_places) == length(places)
    end
  end
end

defmodule Backend.VacationTest do
  use Backend.DataCase, async: false

  alias Backend.Vacation
  alias Backend.Vacation.{Review, Booking}

  describe "get place by slug" do
    test "returns the place with the given slug" do
      place = place_fixture
      vacation_place = Vacation.get_place_by_slug!(place.slug)
      assert vacation_place == place
    end
  end

  @tag :skip
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

      criteria = %{filter: %{pool: true}}

      vacation_places = Vacation.list_places(criteria)

      assert vacation_places |> Enum.map(& &1.name) == ["Place 2"]
    end

    test "returns places filtered by wifi" do
      places_fixture

      criteria = %{filter: %{wifi: true}}

      results = Vacation.list_places(criteria)

      assert Enum.map(results, & &1.name) == ["Place 1", "Place 3"]
    end

    test "returns places filtered by guest count" do
      places_fixture()

      criteria = %{filter: %{guest_count: 3}}

      results = Vacation.list_places(criteria)

      assert Enum.map(results, & &1.name) == ["Place 3"]
    end

    # test "returns places available between dates" do
    #   user = user_fixture()
    #   place = place_fixture()

    #   booking_fixture(user, %{
    #     place_id: place.id,
    #     start_date: ~D[2019-01-05],
    #     end_date: ~D[2019-01-10]
    #   })

    #   # Existing booking period:
    #   #        01-05    01-10
    #   # --------[---------]-------
    #   # Case 1
    #   # --------[---------]-------
    #   assert places_available_between(~D[2019-01-05], ~D[2019-01-10]) == []

    #   # Case 2
    #   # --------[----]------------
    #   assert places_available_between(~D[2019-01-05], ~D[2019-01-08]) == []

    #   # Case 3
    #   # -------------[----]-------
    #   assert places_available_between(~D[2019-01-08], ~D[2019-01-10]) == []

    #   # Case 4
    #   # [-----]-------------------
    #   assert places_available_between(~D[2019-01-01], ~D[2019-01-04]) == [place]

    #   # Case 5
    #   # --------------------[----]
    #   assert places_available_between(~D[2019-01-11], ~D[2019-01-12]) == [place]

    #   # Case 6
    #   # -----[----]---------------
    #   assert places_available_between(~D[2019-01-04], ~D[2019-01-05]) == []

    #   # Case 7
    #   # -----------[---]----------
    #   assert places_available_between(~D[2019-01-07], ~D[2019-01-08]) == []

    #   # Case 8
    #   # ------[-------]-----------
    #   assert places_available_between(~D[2019-01-04], ~D[2019-01-08]) == []

    #   # Case 9
    #   # --------------[--------]--
    #   assert places_available_between(~D[2019-01-08], ~D[2019-01-12]) == []

    #   # Case 10
    #   # -----[----------------]---
    #   assert places_available_between(~D[2019-01-03], ~D[2019-01-12]) == []
    # end
  end

  defp places_available_between(start_date, end_date) do
    args = [
      {:filter,
       [
         {
           :available_between,
           %{start_date: start_date, end_date: end_date}
         }
       ]}
    ]

    Vacation.list_places(args)
  end
end

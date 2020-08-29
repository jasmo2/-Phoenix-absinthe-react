defmodule Backend.Vacation do
  @moduledoc """
  The Vacation context.
  """

  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.Vacation.{Place, Booking, Review}
  alias Backend.Accounts.User

  @doc """
  Returns the list of places.

  ## Examples

      iex> list_places()
      [%Place{}, ...]

  """
  def list_places do
    Repo.all(Place)
  end

  @doc """
  Gets a single place.

  Raises `Ecto.NoResultsError` if the Place does not exist.

  ## Examples

      iex> get_place_by_slug!('slug')
      %Place{}

      iex> get_place_by_slug!(456)
      ** (Ecto.NoResultsError)

  """
  def get_place_by_slug!(slug), do: Repo.get_by!(Place, slug: slug)

  def list_places(criteria) do
    query = from(p in Place)

    Enum.reduce(criteria, query, fn
      {:limit, limit}, query ->
        from p in query, limit: ^limit

      {:filter, filters}, query ->
        filter_with(filters, query)

      {:order, order}, query ->
        from p in query, order_by: [{^order, :id}]
    end)
    |> Repo.all()
  end

  defp filter_with(filters, query) do
    Enum.reduce(filters, query, fn
      {:matching, term}, query ->
        pattern = "%#{term}%"

        from q in query,
          where:
            ilike(q.name, ^pattern) or
              ilike(q.description, ^pattern) or
              ilike(q.location, ^pattern)

      {:pet_friendly, value}, query ->
        from q in query, where: q.pet_friendly

      {:pool, value}, query ->
        from q in query, where: q.pet_friendly == ^value

      {:wifi, value}, query ->
        from q in query, where: q.wifi == ^value

      {:guest_count, count}, query ->
        from q in query, where: q.max_guests >= ^count

      {:available_between, %{start_date: start_date, end_date: end_date}}, query ->
        available_between(query, start_date, end_date)
    end)
  end

  """
  TODO:
  clarify the query below. Why is doing it?
  """

  # This method return places between
  # start_date and end_date.
  # It uses the PostgreSQL OVERLAPS to calculate it.
  defp available_between(query, start_date, end_date) do
    from place in query,
      left_join: booking in Booking,
      on:
        booking.place_id == place.id and
          fragment(
            "(?, ?) OVERLAPS (?, ? + INTERVAL '1' DAY)",
            booking.start_date,
            booking.end_date,
            type(^start_date, :date),
            type(^end_date, :date)
          ),
      where: is_nil(booking.place_id)
  end

  @doc """
  Returns the booking with the given `id`.

  Raises `Ecto.NoRsultsError` if no booking was found.
  """
  def get_booking!(id) do
    Repo.get!(Booking, id)
  end

  @doc """
  Creates a booking for the given user
  """
  def create_booking(%User{} = user, attrs) do
    %Booking{}
    |> Booking.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Cancels the given booking
  """
  def cacel_booking(%Booking{} = booking) do
    booking
    |> Booking.cancel_changeset(%{state: "canceled"})
    |> Repo.update()
  end

  def create_review(%User{} = user, attrs) do
    %Review{}
    |> Review.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end
end

alias Backend.Repo
alias Backend.Vacation.{Booking, Place, Review}
alias Backend.Accounts.User

"""
@doc Users creation
"""

mike =
  %User{}
  |> User.changeset(%{
    username: "mike",
    email: "mike@example.com",
    password: "secret"
  })
  |> Repo.insert!()

nicole =
  %User{}
  |> User.changeset(%{
    username: "nicole",
    email: "nicole@example.com",
    password: "secret"
  })
  |> Repo.insert!()

beachbum =
  %User{}
  |> User.changeset(%{
    username: "brachbum",
    email: "beachbum@example.com",
    password: "secret"
  })
  |> Repo.insert!()

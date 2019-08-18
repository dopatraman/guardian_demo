defmodule GuardianDemo.User.Schema do
  use Ecto.Schema
  import Ecto.Query
  alias GuardianDemo.Repo

  alias GuardianDemo.User.Schema, as: UserSchema

  @type t() :: %UserSchema{
          id: integer(),
          username: String.t(),
          password: String.t()
        }

  schema "users" do
    field :username, :string
    field :password, :string

    timestamps()
  end

  def get_user_by_id(user_id) do
    from(u in UserSchema, where: u.id == ^user_id)
    |> Repo.one()
  end
end

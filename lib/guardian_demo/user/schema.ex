defmodule GuardianDemo.User.Schema do
  use Ecto.Schema
  import Ecto.Changeset

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
end

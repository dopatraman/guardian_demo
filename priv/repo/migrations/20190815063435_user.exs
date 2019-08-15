defmodule GuardianDemo.Repo.Migrations.User do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :password, :string

      timestamps()
    end
  end
end

defmodule GuardianDemoWeb.SessionController do
  use GuardianDemoWeb, :controller
  import Ecto.Query
  # alias Api.Auth.Guardian
  alias GuardianDemo.Repo
  alias GuardianDemo.User.Schema, as: UserSchema

  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
    {:ok, _} =
      get_user_by_username(username)
      |> check_password(password)

    json(conn, :ok)
  end

  defp get_user_by_username(username) do
    from(u in UserSchema, where: u.username == ^username)
    |> Repo.one()
  end

  defp check_password(nil, _), do: {:error, :not_found}

  defp check_password(user, given_password) do
    case Bcrypt.verify_pass(given_password, user.password) do
      true -> {:ok, user}
      _ -> {:error, :unauthorized}
    end
  end
end

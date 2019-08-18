defmodule GuardianDemoWeb.SessionController do
  use GuardianDemoWeb, :controller
  import Ecto.Query
  # alias Api.Auth.Guardian
  alias GuardianDemo.Repo
  alias GuardianDemo.User.Schema, as: UserSchema
  alias GuardianDemo.Guardian

  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
    get_user_by_username(username)
    |> check_password(password)
    |> sign_in(conn)
  end

  defp sign_in({:ok, user}, conn) do
    conn = Guardian.Plug.sign_in(conn, user)
    token = Guardian.Plug.current_token(conn)

    conn
    |> put_resp_header("authorization", "Bearer #{token}")
    |> json(:ok)
  end

  defp sign_in({:error, _}, conn) do
    put_status(conn, 401)
    |> json(:error)
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

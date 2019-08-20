defmodule GuardianDemoWeb.PrivateControllerTest do
  alias GuardianDemoWeb.Router.Helpers, as: Routes
  alias GuardianDemoWeb.Endpoint
  import GuardianDemo.Test.Factory
  import Plug.Conn, only: [get_resp_header: 2, put_req_header: 3]
  use GuardianDemoWeb.ConnCase

  defp get_token(conn, user, password) do
    [token] =
      conn
      |> put_req_header("content-type", "application/json")
      |> post(
        Routes.session_path(Endpoint, :login,
          user: %{
            "username" => user.username,
            "password" => password
          }
        )
      )
      |> get_resp_header("authorization")

    {:ok, token}
  end

  defp add_auth_header(conn, user, raw_password) do
    {:ok, token} = get_token(conn, user, raw_password)
    put_req_header(conn, "authorization", token)
  end

  setup %{conn: conn, authenticate: authenticate} do
    raw_password = "pwnage"
    user = insert(:user, password: Bcrypt.hash_pwd_salt(raw_password))

    conn =
      case authenticate do
        true -> add_auth_header(conn, user, raw_password)
        _ -> conn
      end

    %{
      conn: conn
    }
  end

  @tag authenticate: true
  test "authenticated request to private path", %{conn: conn} do
    post(
      conn,
      Routes.private_path(Endpoint, :my_path, %{
        "foo" => "bar"
      })
    )
    |> json_response(200)
  end

  @tag authenticate: false
  test "unauthenticated request to private path", %{conn: conn} do
    post(
      conn,
      Routes.private_path(Endpoint, :my_path, %{
        "foo" => "bar"
      })
    )
    |> json_response(401)
  end

  @tag authenticate: false
  test "unauthenticated request followed by authenticated request", %{conn: conn} do
    post(
      conn,
      Routes.private_path(Endpoint, :my_path, %{
        "foo" => "bar"
      })
    )
    |> json_response(401)

    raw_password = "pwnage"
    user = insert(:user, password: Bcrypt.hash_pwd_salt(raw_password))
    conn = add_auth_header(conn, user, raw_password)

    post(
      conn,
      Routes.private_path(Endpoint, :my_path, %{
        "foo" => "bar"
      })
    )
    |> json_response(200)
  end
end

defmodule GuardianDemoWeb.SessionControllerTest do
  alias GuardianDemoWeb.Router.Helpers, as: Routes
  alias GuardianDemoWeb.Endpoint
  import GuardianDemo.Test.Factory
  import Plug.Conn, only: [get_resp_header: 2]
  use GuardianDemoWeb.ConnCase

  test "get login token successfully", %{conn: conn} do
    raw_password = "password"
    user = insert(:user, password: Bcrypt.hash_pwd_salt(raw_password))

    resp =
      conn
      |> put_req_header("content-type", "application/json")
      |> post(login_endpoint(user, raw_password))

    [token] = get_resp_header(resp, "authorization")

    assert token !== nil

    json_response(resp, 200)
  end

  test "bad login", %{conn: conn} do
    bad_raw_password = "bad_password"
    raw_password = "password"
    user = insert(:user, password: Bcrypt.hash_pwd_salt(raw_password))

    _resp =
      conn
      |> put_req_header("content-type", "application/json")
      |> post(
        Routes.session_path(Endpoint, :login,
          user: %{
            "username" => user.username,
            "password" => bad_raw_password
          }
        )
      )
      |> json_response(401)
  end

  defp login_endpoint(user, password) do
    Routes.session_path(Endpoint, :login,
      user: %{
        "username" => user.username,
        "password" => password
      }
    )
  end
end

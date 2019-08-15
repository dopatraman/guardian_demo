defmodule GuardianDemoWeb.PageControllerTest do
  alias GuardianDemoWeb.Router.Helpers, as: Routes
  alias GuardianDemoWeb.Endpoint
  import GuardianDemo.Test.Factory
  import Plug.Conn, only: [get_resp_header: 2, put_req_header: 3]
  use GuardianDemoWeb.ConnCase

  defp get_token(conn, user, password), do: {:ok, "token"}

  defp add_auth_header(conn, user, raw_password) do
    {:ok, token} = get_token(conn, user, raw_password)
    put_req_header(conn, "authorization", token)
  end

  setup %{conn: conn} do
    raw_password = "pwnage"
    user = insert(:user, password: Bcrypt.hash_pwd_salt(raw_password))

    %{
      conn: add_auth_header(conn, user, raw_password)
    }
  end

  test "authenticated request", %{conn: conn} do
    resp =
      post(
        conn,
        # this doesn't exist
        Routes.private_path(Endpoint, :my_path, %{
          "foo" => "bar"
        })
      )
      |> json_response(200)
  end
end

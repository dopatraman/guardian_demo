defmodule GuardianDemoWeb.PrivateController do
  use GuardianDemoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
  
  def my_path(conn, _params) do
    json(conn, :ok)
  end
end

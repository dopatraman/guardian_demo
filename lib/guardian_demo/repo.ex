defmodule GuardianDemo.Repo do
  use Ecto.Repo,
    otp_app: :guardian_demo,
    adapter: Ecto.Adapters.Postgres
end

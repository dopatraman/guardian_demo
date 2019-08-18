defmodule GuardianDemo.VerifyAuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :guardian_demo,
    error_handler: GuardianDemo.ErrorHandler,
    module: GuardianDemo.Guardian

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.LoadResource
end

defmodule GuardianDemo.Guardian do
  use Guardian, otp_app: :guardian_demo
  alias GuardianDemo.User.Schema, as: UserSchema

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => user_id}) do
    case UserSchema.get_user_by_id(user_id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end
end

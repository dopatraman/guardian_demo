defmodule GuardianDemo.Test.Factory do
  use ExMachina.Ecto, repo: GuardianDemo.Repo

  alias GuardianDemo.User.Schema, as: UserSchema

  # BCrypt makes this factory slow
  # Use a derived factory instead
  # for user_with_encrypted_pw and not
  # https://github.com/thoughtbot/ex_machina
  def user_factory do
    %UserSchema{
      username: Faker.Pokemon.name(),
      password: Bcrypt.hash_pwd_salt(Faker.Lorem.word())
    }
  end
end

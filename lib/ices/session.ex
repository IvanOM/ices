defmodule Ices.Session do
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  alias Ices.{Repo, User}

  def authenticate(%{"email" => email, "password" => password}) when not (is_nil(email) and is_nil(password)) do
    user = Repo.get_by(User, email: String.downcase(email))

    case check_password(user, password) do
      true -> {:ok, user}
      _ -> :error
    end
  end
  def authenticate(_), do: :error

  defp check_password(user, password) do
    case user do
      nil -> dummy_checkpw()
      _   -> checkpw(password, user.password_hash)
    end
  end
end

defmodule Ices.User do
  use Ices.Web, :model
  import Ices.Gettext

  schema "users" do
    field :name, :string
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email])
    |> downcase_email
    |> validate_required([:name, :email])
    |> validate_format(:email, ~r/.+@.+\..+/)
    |> unique_constraint(:email, message: gettext("Já foi utilizado"))
  end

  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> password_changeset(params)
  end

  def password_changeset(changeset, params) do
    changeset
    |> cast(params, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 100, message: gettext("A senha deve ser formada por pelo menos seis caracteres"))
    |> put_pass_hash()
  end

  defp downcase_email(changeset) do
    case get_field(changeset, :email) do
      nil -> changeset
      email -> put_change(changeset, :email, String.downcase(email))
    end
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end

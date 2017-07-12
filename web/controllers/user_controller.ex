defmodule Ices.UserController do
  use Ices.Web, :controller

  alias Ices.User
  alias Ecto.Multi

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => data} = params) do
    multi = Multi.new
      |> Multi.insert(:user, User.registration_changeset(%User{}, data))

    case Repo.transaction(multi) do
      {:ok, %{user: user}} ->
        user = Repo.get!(User, user.id)
        conn
        |> redirect(to: "/")
      {:error, :user, user_changeset, _changes_so_far} ->
        conn
        |> put_flash(:error, "Não foi possível criar o usuário. Tente novamente ou entre em contato conosco.")
        |> render("new.html", %{changeset: user_changeset})
      {:error, _, _, _changes_so_far} = err ->
        conn
        |> put_flash(:error, "Não foi possível criar o usuário. Tente novamente ou entre em contato conosco.")
        |> redirect(to: user_path(conn, :new))
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end
end

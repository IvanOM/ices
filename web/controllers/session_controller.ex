defmodule Ices.SessionController do
  use Ices.Web, :controller

  plug :scrub_params, "session" when action in [:create]

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => session_params}) do
    case Ices.Session.authenticate(session_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Bem vindo(a)")
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: "/")

      :error ->
        conn
        |> put_flash(:error, "Usuário e/ou senha inválidos")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> Guardian.Plug.sign_out
    |> put_flash(:info, "Até mais.")
    |> redirect(to: "/")
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:info, "Por favor faça o login")
    |> redirect(to: session_path(conn, :new))
  end
end

defmodule Ices.Router do
  use Ices.Web, :router

  def put_current_user(conn, _opts) do
    user = Guardian.Plug.current_resource(conn)
    assign(conn, :current_user, user)
  end

	def put_user_token(conn, _) do
		if current_user = conn.assigns[:current_user] do
			token = Phoenix.Token.sign(conn, "user", current_user.id)
			assign(conn, :user_token, token)
		else
			conn
		end
	end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :browser_auth do
    plug Guardian.Plug.EnsureAuthenticated, handler: Ices.SessionController
    plug :put_current_user
    plug :put_user_token
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Ices do
    pipe_through [:browser, :browser_session] # Use the default browser stack

    resources "/sessions", SessionController, only: [:new, :create]
    delete "/sessions", SessionController, :delete, as: :session
    resources "/users", UserController, only: [:create, :new]


    scope "/" do
      pipe_through [:browser_auth]
      get "/", PageController, :index

      resources "/users", UserController, only: [:index]
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", Ices do
  #   pipe_through :api
  # end
end

defmodule ApiGraphqlWeb.Router do
  use ApiGraphqlWeb, :router
  alias ApiGraphqlWeb.Absinthe.Plug
  alias ApiGraphqlWeb.AbsintheAuthContext
  alias ApiGraphqlWeb.AbsinthePlug
  alias AbsinthePlug.Schema.AuthSchema
  alias AbsinthePlug.AbsintheAuthContext
  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_protected do

    plug :accepts, ["json"]
    plug ApiGraphqlWeb.AbsintheAuthContext
#    plug ApiGraphqlWeb.Auth_plug

  end


  scope "/" do
    pipe_through :api_protected #change to api_protected in prodution

    forward "/graphiql", Absinthe.Plug.GraphiQL,
            schema: ApiGraphqlWeb.Schema.UserSchema,

            interface: :playground,
            context: %{pubsub: ApiGraphqlWeb.Endpoint}

  end

  scope "/gp" do
    pipe_through :api

    forward "/", ApiGraphqlWeb.AbsinthePlug,
            schema: ApiGraphqlWeb.Schema.AuthSchema,
            interface: :playground,
            context: %{pubsub: ApiGraphqlWeb.Endpoint}

  end

  scope "/api", ApiGraphqlWeb do
    pipe_through :api
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: ApiGraphqlWeb.Telemetry
    end
  end
end

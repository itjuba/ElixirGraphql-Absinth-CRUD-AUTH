defmodule ApiGraphqlWeb.Auth_plug do
  alias ApiGraphqlWeb.Accounts.User
  alias ApiGraphqlWeb.Accounts
  alias ApiGraphqlWeb.UserView
  alias Plug.Conn
  import Plug.Conn

  def init(opts), do: opts

  def authenticated(conn) do
    IO.puts "auth function"


    case fetch_access_token(conn) do
      :error -> :error
      {:ok,token} ->
        token
        case verify(token) do
          true -> :valid
          {:invalid} -> {:invalid}
          {:expired} -> {:expired}
        end

    end
  end

  def call(conn, _opts) do
    case authenticated(conn) do
      {:invalid} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(401, Jason.encode!(%{"status" => "401","message" => "Not Authorized : Invalid JWT"}))
        |> halt
      {:expired} ->

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(401, Jason.encode!(%{"status" => "401","message" => "Not Authorized : Expired JWT"}))
        |> halt
      :error ->

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(401, Jason.encode!(%{"status" => "401","message" => "Not Authorized"}))
        |> halt

        conn
      :valid ->
        conn
    end

  end



  def fetch_access_token(conn) do
    tk = Conn.get_req_header(conn, "authorization")
    IO.puts tk
    case Conn.get_req_header(conn, "authorization") do
      [token | _rest] -> {:ok, token}
      _any            -> :error
    end
  end


  def verify(token) do
    IO.inspect token
    data = Phoenix.Token.verify(ApiGraphqlWeb.Endpoint, "user auth", token, max_age: 86400)
    case data do
      {:ok,_} -> true
      {:error,:invalid} -> {:invalid}
      {:error, :expired} -> {:expired}

    end
  end
end
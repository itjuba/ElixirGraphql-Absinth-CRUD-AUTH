defmodule ApiGraphqlWeb.AbsintheAuthContext do
  @behaviour Plug

  import Plug.Conn
  import Ecto.Query, only: [where: 2]

  alias ApiGraphql.{Repo, Accounts}

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  @doc """
  Return the current user context based on the authorization header
  """
  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization") do
      IO.inspect token

    case verify(token) do
      true     -> authorize(token)
      {:invalid} ->
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(401, Jason.encode!(%{"status" => "401","message" => "Not Authorized : Invalid JWT"}))
      |> halt
      {:expired} -> conn
                    |> put_resp_content_type("application/json")
                    |> send_resp(401, Jason.encode!(%{"status" => "401","message" => "Not Authorized : Expired JWT"}))
                    |> halt

    end
    else
      _ -> conn
             |> put_resp_content_type("application/json")
             |> send_resp(401, Jason.encode!(%{"status" => "401","message" => "Not Authorized : Invalid JWT"}))

  end
    end


  defp authorize(token) do
    User

    |> case do
         nil -> {:error, "invalid authorization token"}
         user -> {:ok, user}
                 %{current_user: user}

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
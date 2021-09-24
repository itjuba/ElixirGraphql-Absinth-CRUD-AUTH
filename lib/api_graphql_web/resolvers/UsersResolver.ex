defmodule ApiGraphqlWeb.Resolvers.UsersResolver do
  alias ApiGraphql.Accounts
  alias ApiGraphql.Accounts.User


  def auth(_root, _args, _info) do
    try do

      u = Accounts.get_user_by(_args.email)
      IO.inspect u
      cond do
        u == nil -> {:error, message: "Unable to login with provided credentials ", details: "Wrong email or password"}
        u && Pbkdf2.verify_pass(_args.password, u.password) ->
          {:ok, u}

        u -> {:error, message: "Unable to login with provided credentials ", details: "Wrong email or password"}

      end
    rescue
      Ecto.NoResultsError ->
        {:error, message: "Unable to login with provided credentials ", details: "Wrong email or password"}

    end
  end

  def error_details(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {msg, _} -> msg end)
  end

  def update_user(%{user: attrs}, _resolution) do
    try  do
      user_from_db = Accounts.get_user(%{id: attrs.id})
      if user_from_db == nil do
        IO.inspect "user not found"
        throw("user not found")
      end
      case Accounts.update_user(user_from_db, attrs) do
        {:ok, user} -> {:ok, user}
        {:error, changeset} -> {:error, message: "Could not update user", details: error_details(changeset)}
      end

    catch
      x ->  {:error, message: "User not found"}

    end
  end

  def delete_user(_root, _args, _info) do
    IO.inspect _args.id
    try  do
      user = Accounts.get_user(%{id: _args.id})
      if user == nil do
        throw("user not found")
      end

      #    IO.inspect Accounts.delete_user(user)
      case Accounts.delete_user(user) do
        {:ok, %User{}} -> {:ok , user}
        {:error,_} -> {:error,"Bad request"}

      end
    catch
      x -> {:error , x}
    end
  end

  def all_users(_root, _args, _info) do
    {:ok, Accounts.list_users()}
  end


  def create_user(%{user: attrs}, _resolution) do
    case Accounts.create_user(attrs) do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> {:error, message: "Could not create user", details: error_details(changeset)}
    end
  end

  def get_user_email(_root, _args, _info) do

    user = Accounts.get_user_by(_args.email)

    #    IO.inspect user
    {:ok,user}
  end

  def token_get(id) do
    token = Phoenix.Token.sign(ApiGraphqlWeb.Endpoint, "user auth", id)

    {:ok ,token}
  end


end
defmodule ApiGraphql.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :address, :string
    field :email, :string
    field :name, :string
    field :password, :string
    field :username, :string

    timestamps()
  end


  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password, Pbkdf2.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end
  @doc false
  def changeset(user, attrs) do
    user

    |> cast(attrs, [:username, :email, :name, :password, :address])
    |> unique_constraint(:email)
    |> validate_required([:username, :email, :name, :password, :address])

  end

  def registration_changeset(user, params) do
    user
    |> changeset(params)
    |> cast(params, [:username, :email, :name, :password, :address])
    |> unique_constraint(:email)
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end
end

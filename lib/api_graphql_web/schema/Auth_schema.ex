defmodule ApiGraphqlWeb.Schema.AuthSchema do
  use Absinthe.Schema
  alias ApiGraphqlWeb.Resolvers.UsersResolver
  import_types ApiGraphqlWeb.InputObjects.Types




  def handle_errors(fun) do
    fn source, args, info ->
      case Absinthe.Resolution.call(fun, source, args, info) do
        {:error, %Ecto.Changeset{} = changeset} ->
          {:error , changeset.errors}
      end
    end

  end
  object :token do
    field :token, non_null(:string)
  end






  query do
    @desc "Get all users"
    field :all_users, non_null(list_of(non_null(:users))) do
      resolve(&UsersResolver.all_users/3)
    end



  end

  mutation do
    @desc "Auth"
    field :auth, non_null((:users)) do
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      resolve(&UsersResolver.auth/3)
    end

    @desc "Delete user"
    field :delete_user, non_null((:users)) do
      arg :id, non_null(:id)
      resolve(&UsersResolver.delete_user/3)
    end

    @desc "Get user by email"
    field :get_user_email, non_null((:users)) do
      arg :email, non_null(:string)
      resolve(&UsersResolver.get_user_email/3)
    end

    @desc "Update user "
    field :update_user, type: :users do
      arg :user, :update_user_params
      resolve(&UsersResolver.update_user/2)

    end

    @desc "Create  user by email"
    field :create_user, type: :users, description: "Create a new user" do
      arg :user, :create_user_params
      resolve &UsersResolver.create_user/2
    end
  end


end
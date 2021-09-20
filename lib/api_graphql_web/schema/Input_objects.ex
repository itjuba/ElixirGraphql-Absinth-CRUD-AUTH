defmodule ApiGraphqlWeb.InputObjects.Types do
  use Absinthe.Schema
  alias ApiGraphqlWeb.Resolvers.UsersResolver


  query do
  end
  object :users do
    field :id, non_null(:id)
    field :username, non_null(:string)
    field :name, non_null(:string)
    field :email, non_null(:string)
    field :address, non_null(:string)
    field :token, :string, resolve: fn (query,_,_) ->
      UsersResolver.token_get(query.id)
    end

  end
  input_object :create_user_params, description: "create a user" do
    field :username, non_null(:string), description: "Required first name"
    field :email, non_null(:string), description: "Optional last name"
    field :address, non_null(:string), description: "Age in Earth years"
    field :password, non_null(:string), description: "Age in Earth years"
    field :name, non_null(:string), description: "Age in Earth years"
  end

  input_object :update_user_params, description: "create a user" do
    field :username, (:string), description: "Required first name"
    field :email, (:string), description: "Optional last name"
    field :address, (:string), description: "Age in Earth years"
    field :password, (:string), description: "Age in Earth years"
    field :name, (:string), description: "Age in Earth years"
    field :id, (:id), description: "Age in Earth years"
  end

end

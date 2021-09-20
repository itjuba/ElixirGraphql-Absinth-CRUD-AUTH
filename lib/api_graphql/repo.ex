defmodule ApiGraphql.Repo do
  use Ecto.Repo,
    otp_app: :api_graphql,
    adapter: Ecto.Adapters.Postgres
end

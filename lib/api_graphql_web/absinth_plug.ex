defmodule ApiGraphqlWeb.AbsinthePlug do
  defdelegate init(opts), to: Absinthe.Plug.GraphiQL
  defdelegate call(conn, opts), to: Absinthe.Plug.GraphiQL
end
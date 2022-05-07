defmodule Pubsublive.Repo do
  use Ecto.Repo,
    otp_app: :pubsublive,
    adapter: Ecto.Adapters.Postgres
end

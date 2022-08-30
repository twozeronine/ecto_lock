import Config

config :ecto_lock, EctoLock.Repo,
  database: "ecto_lock_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: 15432

config :ecto_lock, ecto_repos: [EctoLock.Repo]

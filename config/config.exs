import Config

config :ecto_lock, EctoLock.Repo,
  database: "ecto_lock_repo",
  username: "user",
  password: "pass",
  hostname: "localhost"

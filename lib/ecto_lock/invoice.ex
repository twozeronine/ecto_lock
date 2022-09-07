defmodule EctoLock.Invoice do
  use Ecto.Schema

  import Ecto.Changeset, only: [cast: 3]
  import Ecto.Query, only: [from: 2]

  schema "invoices" do
    field(:pending, :boolean)
  end

  # 자신의 테이블을 순회하여 pending이 true인 테이블만 가져옴
  def pending(query \\ __MODULE__) do
    from(i in query, [
      {:where, i.pending == true}
    ])
  end

  def changeset(%EctoLock.Invoice{} = invoice, attrs \\ %{}) do
    invoice
    |> cast(attrs, [:pending])
  end

  def get_and_lock_invoice(query \\ __MODULE__, invoice_id) do
    from(i in query, [
      {:where, i.id == ^invoice_id and i.pending == true},
      {:lock, "FOR UPDATE"}
    ])
  end
end

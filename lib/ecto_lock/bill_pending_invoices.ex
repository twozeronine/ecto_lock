defmodule EctoLock.BillPendingInvoices do
  alias EctoLock.{Invoice, Repo}

  # Invoice 구조체를 만들고 pending을 true바꾼뒤 디비에 저장
  def create_pending_invoice do
    %Invoice{}
    |> Invoice.changeset(%{pending: true})
    |> Repo.insert()
  end

  # 보류된 송장들을 청구함
  def bill_pending_invoices do
    # 보류된 송장들을 모두 가져옴
    Invoice.pending()
    |> Repo.all()
    # 보류된 송장들을 모두 순회하며 청구함
    |> Enum.each(fn invoice -> bill_pending_invoice(invoice.id) end)
  end

  # 보류된 송장 하나를 청구함
  def bill_pending_invoice(invoice_id) do
    fn ->
      # DB에서 해당하는 송장을 가져옴.
      invoice = get_invoice(invoice_id)
      # API를 통해 송장을 청구함. (1초 소요.)
      bill_through_api(invoice)
      # 청구가 완료되면 체크하고 DB에 업데이트함.
      mark_invoice_sent(invoice)
    end
    |> EctoLock.Repo.transaction()
  end

  def get_invoice(id) do
    Invoice
    |> Invoice.get_and_lock_invoice(id)
    |> Repo.one()
  end

  # 송장을 청구하는 어떤 API
  def bill_through_api(invoice) do
    # let's assume it takes a second to hit the API
    IO.puts("Seding invoice #{invoice.id}...")
    :timer.sleep(1_000)
    IO.puts("Invoice #{invoice.id} send!")
  end

  # 청구가 완료된 송장을 체크하고 디비에 업데이트함
  def mark_invoice_sent(invoice) do
    invoice
    |> Invoice.changeset(%{pending: false})
    |> Repo.update()
  end
end

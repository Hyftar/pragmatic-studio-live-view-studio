defmodule LiveViewStudioWeb.SalesLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Sales

  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :tick)
    end

    socket =
      socket
      |> assign_stats()

    {:ok, socket}
  end

  def handle_event("refresh", _, socket) do
    socket =
      socket
      |> assign_stats()

    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    socket =
      socket
      |> assign_stats()

    {:noreply, socket}
  end

  defp assign_stats(socket) do
    socket
    |> assign(
      new_orders: Sales.new_orders(),
      sales_amount: Sales.sales_amount(),
      satisfaction: Sales.satisfaction()
    )
  end

  def render(assigns) do
    ~H"""
    <h1>Snappy Sales 📊</h1>
    <div id="sales">
      <div class="stats">
        <div class="stat">
          <span class="value">
            <%= @new_orders %>
          </span>
          <span class="label">
            New Orders
          </span>
        </div>
        <div class="stat">
          <span class="value">
            $<%= @sales_amount %>
          </span>
          <span class="label">
            Sales Amount
          </span>
        </div>
        <div class="stat">
          <span class="value">
            <%= @satisfaction %>%
          </span>
          <span class="label">
            Satisfaction
          </span>
        </div>
      </div>

      <button phx-click="refresh">
        <img src="/images/refresh.svg" /> Refresh
      </button>
    </div>
    """
  end
end

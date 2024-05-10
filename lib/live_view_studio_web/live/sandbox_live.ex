defmodule LiveViewStudioWeb.SandboxLive do
  use LiveViewStudioWeb, :live_view

  import Number.Currency

  alias LiveViewStudio.Sandbox

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(length: 0)
      |> assign(width: 0)
      |> assign(depth: 0)
      |> assign(weight: 0)
      |> assign(price: nil)

    {:ok, socket}
  end

  def handle_event("change", %{"length" => length, "width" => width, "depth" => depth}, socket) do
    socket =
      socket
      |> assign(length: String.to_integer(length))
      |> assign(width: String.to_integer(width))
      |> assign(depth: String.to_integer(depth))
      |> assign(weight: Sandbox.calculate_weight(socket.assigns.length, socket.assigns.width, socket.assigns.depth))
      |> assign(price: nil)

    {:noreply, socket}
  end

  def handle_event("get_quote", _, socket) do
    socket =
      socket
      |> assign(price: Sandbox.calculate_price(socket.assigns.weight))

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Build A Sandbox</h1>
    <div id="sandbox">
      <form phx-change="change" phx-submit="get_quote">
        <div class="fields">
          <div>
            <label for="length">Length</label>
            <div class="input">
              <input type="number" name="length" value={@length} />
              <span class="unit">feet</span>
            </div>
          </div>
          <div>
            <label for="width">Width</label>
            <div class="input">
              <input type="number" name="width" value={@width} />
              <span class="unit">feet</span>
            </div>
          </div>
          <div>
            <label for="depth">Depth</label>
            <div class="input">
              <input type="number" name="depth" value={@depth} />
              <span class="unit">inches</span>
            </div>
          </div>
        </div>
        <div class="weight">
          You need <%= @weight %> pounds of sand 🏝
        </div>
        <button type="submit">
          Get A Quote
        </button>
      </form>
      <div class="quote" :if={@price}>
        Get your personal beach today for only
        <%= @price |> number_to_currency() %>
      </div>
    </div>
    """
  end
end

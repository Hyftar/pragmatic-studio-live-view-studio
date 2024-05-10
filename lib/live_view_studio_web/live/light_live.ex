defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(brightness: 10)

    {:ok, socket}
  end

  def handle_event("down", _, socket) do
    socket = update(socket, :brightness, &max(&1 - 10, 0))

    {:noreply, socket}
  end

  def handle_event("up", _, socket) do
    socket = update(socket, :brightness, &min(&1 + 10, 100))

    {:noreply, socket}
  end

  def handle_event("toggle", _, socket) do
    socket = update(socket, :brightness, fn val -> if val == 0, do: 100, else: 0 end)

    {:noreply, socket}
  end

  def handle_event("rand", _, socket) do
    socket = update(socket, :brightness, Enum.random(0..100))

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div id="light">
      <h1>Light</h1>
      <div class="meter">
        <span style={"width: #{@brightness}%"}>
          <%= @brightness %>%
        </span>
      </div>
      <div class="actions flex align-center justify-center">
        <button phx-click="down">
          -
        </button>
        <button phx-click="toggle">
          Toggle
        </button>
        <button phx-click="rand">
          <image src="/images/fire.svg" />
        </button>
        <button phx-click="up">
          +
        </button>
      </div>
    </div>
    """
  end
end

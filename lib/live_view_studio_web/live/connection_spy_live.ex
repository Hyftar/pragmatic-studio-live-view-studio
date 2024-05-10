defmodule LiveViewStudioWeb.ConnectionSpyLive do
  require IEx
  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(remote_ip: get_connect_info(socket, :peer_data))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-center">🧑‍💻 Connection Spy</h1>
    <div class="flex justify-center mt-4">
      <pre>
        <%= inspect(@remote_ip) %>
      </pre>
    </div>
    """
  end
end

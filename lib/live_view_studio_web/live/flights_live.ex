defmodule LiveViewStudioWeb.FlightsLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Flights
  alias LiveViewStudio.Airports

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        airport: "",
        flights: Flights.list_flights(),
        matches: %{},
        loading: false
      )

    {:ok, socket}
  end

  def handle_event("search", %{"airport" => airport}, socket) do
    send(self(), {:run_search, airport})

    socket =
      socket
      |> assign(airport: airport)
      |> assign(flights: [])
      |> assign(loading: true)

    {:noreply, socket}
  end

  def handle_event("suggest", %{"airport" => prefix}, socket) do
    socket =
      socket
      |> assign(matches: Airports.suggest(prefix))

    {:noreply, socket}
  end

  def handle_info({:run_search, airport}, socket) do
    socket =
      socket
      |> assign(flights: Flights.search_by_airport(airport))
      |> assign(loading: false)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Find a Flight</h1>
    <div id="flights">
      <form phx-submit="search">
        <input
          type="text"
          name="airport"
          value={@airport}
          placeholder="Airport Code"
          autofocus
          autocomplete="off"
          readonly={@loading}
          list="matches"
          phx-change="suggest"
          phx-debounce="500"
        />

        <datalist id="matches">
          <option :for={{code, name} <- @matches} value={code}>
            <%= "#{code} - #{name}" %>
          </option>
        </datalist>

        <button>
          <img src="/images/search.svg" />
        </button>
      </form>

      <div class="loader" :if={@loading}>loading... </div>

      <div class="empty mt-4" :if={!@loading && @flights == []}>
        No flights found for <%= @airport %>
      </div>

      <div class="flights">
        <ul>
          <li :for={flight <- @flights}>
            <div class="first-line">
              <div class="number">
                Flight #<%= flight.number %>
              </div>
              <div class="origin-destination">
                <%= flight.origin %> to <%= flight.destination %>
              </div>
            </div>
            <div class="second-line">
              <div class="departs">
                Departs: <%= flight.departure_time %>
              </div>
              <div class="arrives">
                Arrives: <%= flight.arrival_time %>
              </div>
            </div>
          </li>
        </ul>
      </div>
    </div>
    """
  end
end

defmodule MonitorWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:lobby", _message, socket) do
    send self(), :after_join
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    project =
    case socket.assigns.project do
      nil -> []
      [] -> []
      proj -> Enum.map( proj, fn {_, value} -> String.to_integer(value) end)
    end
    push socket, "update_pipelines", %{
      pipelines: Monitor.PipelineCache.get_pipelines project
    }
    {:noreply, socket}
  end
end

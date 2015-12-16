defmodule Yorsbil.PageController do
  use Yorsbil.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

end

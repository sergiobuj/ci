defmodule Ciserver.Handler do
  def prepare_headers do
    [{"content-type", "application/json"}]
  end

  def init({:tcp, :http}, req, opts) do
    {:ok, req, opts}
  end

  def handle(req, state) do
    {method, req} = :cowboy_req.method(req)
    {event, req} = :cowboy_req.header("x-github-event", req, "")

    case {method, event} do
      {"POST", "pull_request"} -> handle_pr_post(req, state)
      {"POST", "issue_comment"} -> handle_comment_post(req, state)
      _ -> handle_404(req, event, state)
    end

  end

  def handle_pr_post(request, state) do
    {:ok, body, request} = :cowboy_req.body(request)
    IO.puts is_binary(body) # true
    IO.puts is_bitstring(body) # true
    resp = Poison.Parser.parse!(body)
    IO.puts "->"
    IO.puts resp['pull_request'] # empty
    #reviewers = Cypiserver.Util.reviewers_for_pr(body)
    reviewers = ["1", "2"]
    {:ok, resp} = :cowboy_req.reply(204, prepare_headers(), reviewers, request)
    {:ok, resp, state}
  end

  def handle_comment_post(request, state) do
    {:ok, resp} = :cowboy_req.reply(204, prepare_headers(), "", request)
    {:ok, resp, state}
  end

  def handle_404(request, event, state) do
    {:ok, resp} = :cowboy_req.reply(404, prepare_headers(), event, request)
    {:ok, resp, state}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end

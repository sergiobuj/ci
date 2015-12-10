defmodule Ciserver.Util do

#  (defun pr-reviewers (pr-body)
#    (clean-usernames
#      (: lists merge
#        (: lists filtermap #'required-pr-line/1
#           (: string tokens pr-body "\n")))))
#
#  (defun required-pr-line (line)
#    (let ((word (string:tokens line " ")))
#      (cond ((== "required" (car word)) (tuple 'true (cdr word)))
#            ('true 'false))))
#
#  (defun clean-usernames (usernames)
#    " car-ing the elements of a string will give the (binary?) representation,
#    thus the 64 for @"
#    (let* ((handlers (: lists filter (lambda (x) (== 64 (car x))) usernames))
#           (handlersset (: sets from_list handlers)))
#      (: lists sort (: sets to_list handlersset))))

  def required_pr_line(line) do
    [head | tail] = String.split(line, " ")
    is_required = String.match?(head, ~r/required(?:)/i)

    if is_required do
      tail
    else
      []
    end
  end

  def get_pr_body(req_body) do
    {:ok, resp} = JSON.decode(req_body)
    resp["pull_request"]
  end

  def reviewers_for_pr(req_body) do
    pr_body = get_pr_body(req_body)
    String.split(pr_body, "\n") |> Enum.map(&required_pr_line/1)
  end
end

require 'net/http'
require 'json'
require 'uri'
class IssueController < ActionController::Base
  protect_from_forgery with: :null_session

  def show
    @success = false
    @body = "## Description

## Blocked By

## Database

## Technical Details

## QA Notes"
    render "show.html.erb"
  end

  def create
    title = params[:title]
    body = params[:body]
    author = params[:author]
    repo = params[:repo]

    if title.blank? || body.blank? || author.blank? || repo.blank?
      errors = []
      errors << "please provide a title" if title.blank?
      errors << "please provide a body" if body.blank?
      errors << "please provide github repo author" if author.blank?
      errors << "please provide repo" if repo.blank?
      @errors = errors
      render "show"
      return
    end

    Rails.logger.info(:event => "valid_form")

    tok = ENV['GH_TOKEN']
    if tok.blank?
      @errors = ["missing github token"]
      render "show"
      return
    end

    base_url = "https://api.github.com"
    create_path = "/repos/#{author}/#{repo}/issues"
    issue_body = {
      :title => title,
      :body => body,
    }.transform_keys(&:to_s).to_json

    Rails.logger.info(:event => "creating_new_issue", :issue => issue_body)

    request = Net::HTTP::Post.new(create_path)
    request["Authorization"] = "token #{tok}"
    request.body = issue_body
    uri = URI.parse(base_url)
    client = Net::HTTP.new(uri.host, uri.port)
    client.use_ssl = true
    rsp = client.request(request)

    if rsp.code != "201"
      Rails.logger.error(:event => "bad_call", :response => rsp, :body => rsp.body)
      @errors = [
        "there may have been and error, unexpected response: #{rsp.code}",
        rsp.body,
    ]
      render "show"
      return
    end

    @success = true
    render "show"
  end
end
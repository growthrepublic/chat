require 'ostruct'

module PageFixtures
  def open_fixture(name, data = {})
    query = CGI.unescape(data.to_query)
    path = "/page_fixtures/#{name}?#{query}"
    visit(path)
  end

  def server_host_with_port
    [Capybara.server_host, Capybara.server_port].compact.join(':')
  end
end

class PageFixturesController < ApplicationController
  self.view_paths = "spec"
  layout nil

  def show
    @data = OpenStruct.new(params[:data] || {})
    render params[:id].to_s
  end
end

test_routes = Proc.new do
  resources :page_fixtures, only: [:show]
end

Rails.application.routes.eval_block(test_routes)
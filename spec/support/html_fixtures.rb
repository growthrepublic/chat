module HtmlFixtures
  def open_test_fixture(name, data = {})
    query = CGI.unescape(data.to_query)
    path = "/test_fixtures/#{name}?#{query}"
    visit(path)
  end

  def server_host_with_port
    [Capybara.server_host, Capybara.server_port].compact.join(':')
  end
end
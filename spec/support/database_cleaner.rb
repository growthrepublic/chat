RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.around(:each) do |example|
    DatabaseCleaner.strategy = if example.metadata[:js] || example.metadata[:type] == 'feature'
      :truncation
    else
      :transaction
    end
    DatabaseCleaner.start

    example.run

    Capybara.reset_sessions!
    DatabaseCleaner.clean
  end
end
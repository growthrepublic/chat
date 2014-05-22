begin
  require 'rspec/rails'
rescue NameError => ex
  if ex.message =~ /RSpec::Rails::FixtureSupport/
    module RSpec
      module Rails
        module FixtureSupport
        end
      end
    end
    retry
  else
    raise
  end
end

RSpec.configure do |config|
  config.include RSpec::Rails::RequestExampleGroup, type: :request
end
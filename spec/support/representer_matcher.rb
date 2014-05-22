RSpec::Matchers.define :be_representation_of do |expected|
  match do |actual|
    unless @presenter_class
      raise ArgumentError, "use :with to provide presenter class"
    end

    actual == JSON.parse(@presenter_class.new(expected).to_json)
  end

  chain :with do |presenter_class|
    @presenter_class = presenter_class
  end

  failure_message do |actual|
    "expected that #{actual} would be a representation of #{expected}" +
    " with #{@presenter_class}"
  end

  failure_message_when_negated do |actual|
    "expected that #{actual} would not be a representation of #{expected}" +
    " with #{@presenter_class}"
  end

  description do
    "be a representation of #{expected} with #{@presenter_class}"
  end
end
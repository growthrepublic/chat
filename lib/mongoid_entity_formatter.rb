module MongoidEntityFormatter
  extend ActiveSupport::Concern

  FORMATTERS = {
    id: ->(value) { value.to_s }
  }

  module ClassMethods
    def expose_mongo_id(attr_name, &block)
      expose attr_name do |receiver, options|
        value = if block
          block.call(receiver, options)
        else
          receiver.public_method(attr_name).call
        end

        FORMATTERS[:id].call(value)
      end
    end
  end
end
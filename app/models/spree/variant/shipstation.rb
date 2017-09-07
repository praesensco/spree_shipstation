module Spree
  class Variant < Spree::Base
    module Shipstation
      def shipstation_options
        option_values.map do |ov|
          {
            name: ov.option_type.presentation,
            value: ov.presentation
          }
        end
      end
    end
  end
end

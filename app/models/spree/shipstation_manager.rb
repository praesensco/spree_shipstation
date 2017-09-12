class Spree::ShipstationManager
  ALLOWED_ACTIONS = %i[export_orders].freeze

  def initialize(action, verbose = false)
    return unless ALLOWED_ACTIONS.include?(action)
    @verbose = verbose
    send(action)
  end

  private

  def export_order(order)
    if @verbose
      puts "Spree::ShipstationManager export order #{order.number}"
    end
    response = Shipstation::Order.create order.shipstation_params
    order.shipstation_exported!
    if @verbose
      puts "> Exported"
    end
    raise prepare_error_message(response, order) if response.class != Hash
    raise prepare_error_message(response['Message'], order) if response['Message'].present?
    response
  end

  def export_orders
    if @verbose
      puts "Spree::ShipstationManager export_orders #{collect_export_orders.size}"
    end
    collect_export_orders.each do |order|
      begin
        export_order order
      rescue => error
        MassNotifier::Notification.new('Error::Shipstation.export_orders', error.message)
        next
      end
    end
  end

  def prepare_error_message(message, order)
    "Shipstation Export Error: #{message}\n\nOrder: #{order.shipstation_params}"
  end

  def collect_export_orders
    if @verbose
      puts "Spree::ShipstationManager collect_export_orders"
    end
    Spree::Order.complete.where(shipstation_exported_at: nil).limit(1)
  end
end

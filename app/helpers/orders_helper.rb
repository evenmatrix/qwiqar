module OrdersHelper
  class PaymentMethod
    attr_accessor :name, :id ,:klass

    def initialize(attributes = {})
      attributes.each do |n, v|
        send("#{n}=", v)
      end
    end
  end

  def payment_methods
    interswitch_gateway=PaymentProcessor.where(:name=>"Interswitch").first
    @payment_methods = [
        PaymentMethod.new(:name => "Master Card", :id => interswitch_gateway.id,:klass=>"master-card"),
        PaymentMethod.new(:name => "Verve Card", :id => interswitch_gateway.id,:klass=>"verve-card")
    ]
  end

end

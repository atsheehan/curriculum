require_relative '../lib/order'

describe Order do
  before :each do
    item_attrs = [{
      name: "Magnifying Glass",
      manufacturer: "Spys-R-Us",
      price: 5.75,
      description: "Great for inspecting clues."
    }, {
      name: "Spy Notebook",
      manufacturer: "Spys-R-Us",
      price: 10.50
    }]

    @order = Order.new(
      placed_at: "12/10/2014",
      customer: "Gene Parmesan",
      payment_method: "PayPal",
      shipping_address: "100 Spy Street, Newport Beach, CA 92625"
    )

    item_attrs.each do |attrs|
      @order.items << Item.new(attrs)
    end
  end

  describe '#total' do
    it 'returns the total cost of the items' do
      expect(@order.total).to eq(16.25)
    end
  end

  describe '#summary' do
    it 'returns summary information' do
      expected_summary = %q(
Date: 12/10/2014
Customer: Gene Parmesan
Payment method: PayPal
Shipping address: 100 Spy Street, Newport Beach, CA 92625

Items:

Name: Magnifying Glass
Description: Great for inspecting clues.
Manufacturer: Spys-R-Us
Price: $5.75

Name: Spy Notebook
Manufacturer: Spys-R-Us
Price: $10.50

Total: $16.25
      )
      expect(@order.summary).to eq(expected_summary)
    end
  end
end

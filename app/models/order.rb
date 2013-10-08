class Order < ActiveRecord::Base
  has_many :line_items, :dependent => :destroy
  attr_accessible :first_name, :last_name, :billing_company, :billing_address, :billing_city, :billing_county, :billing_postcode, :billing_country, :billing_telephone, :delivery_address, :delivery_city, :delivery_county, :delivery_postcode, :delivery_country, :delivery_telephone, :email, :tax_number, :total, :total_vat, :shipping_cost, :payment_status, :shipping_status, :shipping_date, :terms
  validates :first_name, :last_name, :email, :billing_address, :billing_city, :billing_county, :billing_postcode, :billing_country, :delivery_address, :delivery_city, :delivery_county, :delivery_postcode, :delivery_country, :presence => true
  validates_format_of :email, :with => /@/
  validates :terms, :acceptance => {:message => "Please accept the Terms & Conditions."}
  after_update :send_new_ship_email, :if => :ship_date_changed? && :no_ship_date
  after_update :send_changed_ship_email, :if => :ship_date_changed? && :ship_date_was

  def add_line_items_from_cart(cart)
  	cart.line_items.each do |item|
  		item.cart_id = nil
  		line_items << item
  	end
  end

  def no_ship_date
    self.ship_date_was.nil?
  end

  def send_new_ship_email
    Notifier.order_shipped(self).deliver
  end

  def send_changed_ship_email
    Notifier.changed_shipping(self).deliver
  end
end

class Ingredient
  attr_accessor :name, :quantity, :price

  def initialize(name, quantity, price)
    @name = name
    @quantity = quantity.to_i
    @price = price.to_f
  end

  def total_cost
    @quantity * @price
  end

  def to_s
    "#{@name} | Qty: #{@quantity} | Price: ₱#{@price.round(2)} | Total: ₱#{total_cost.round(2)}"
  end
end

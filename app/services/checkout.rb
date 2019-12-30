class Checkout
  def initialize(promotion_rules)
    @promotion_rules = promotion_rules
    @items = []
  end

  def scan(item)
    @items << item
  end

  def total
    get_attributes
    priority_discount
    @total.round(2)
  end

  private

  def priority_discount
    quantity_discount
    price_discount
  end

  def get_attributes
    @items_map = @items.each_with_object(Hash.new(0)) { |h1, h2| h2[h1[:product_code]] += 1 }
    @prices = @items.each_with_object(Hash.new(0)) { |h1, h2| h2[h1[:product_code]] = h1[:price] }
    price_count
  end

  def price_discount
    promotion_discount = {}
    promotion = false
    @promotion_rules.each do |rule|
      if rule.type == :discount_by_total && @total >= rule.value_discount
        promotion_discount[rule.id] = (@total * rule.discount / 100)
        promotion = true
      end
    end
    @total -= promotion_discount.values.max if promotion
  end

  def quantity_discount
    promotion = false
    @promotion_rules.each do |rule|
      if rule.type == :discount_by_product && @items_map[rule.product_code] >= rule.value_discount && @prices[rule.product_code] > rule.discount
        @prices[rule.product_code] = rule.discount
        promotion = true
      end
    end
    price_count if promotion
  end

  def price_count
    total_price = 0
    @items_map.each do |key, value|
      total_price += (@prices[key] * value)
    end
    @total = total_price
  end
end

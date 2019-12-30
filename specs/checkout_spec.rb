require_relative "../app/models/product.rb"
require_relative "../app/models/promotion_rule.rb"
require_relative "../app/services/checkout.rb"

require 'pry-rails'

RSpec.describe Checkout do
  describe 'Test data' do
    let(:item_1) { Product.new(001, 'Lavender heart', 9.25) }
    let(:item_2) { Product.new(002, 'Personalised cufflinks', 45.00) }
    let(:item_3) { Product.new(003, 'Kids T-shirt', 19.95) }
    let(:promotion_rule_1) { PromotionRule.new(1, :discount_by_total, nil, 60, 10) }
    let(:promotion_rule_2) { PromotionRule.new(2, :discount_by_product, 001, 2, 8.50)}
    let(:promotion_rule_3) { PromotionRule.new(3, :discount_by_product, 003, 3, 19)}
    let(:promotional_rules){ [promotion_rule_1, promotion_rule_2, promotion_rule_3] }

    context 'default total price' do
      let(:checkout){
        co = Checkout.new(promotional_rules)
      }
      before { checkout }
      it 'Total price expected: £0' do
        expect(checkout.total == 0).to be true
      end
    end

    context 'Wish list: 001,002,003' do
      let(:checkout){
        co = Checkout.new(promotional_rules)
        co.scan(item_1)
        co.scan(item_2)
        co.scan(item_3)
        co
      }
      before { checkout }
      it 'Total price expected: £66.78' do
        expect(checkout.total == 66.78).to be true
      end
    end

    context 'Wish list: 001,001,003' do
      let(:checkout){
        co = Checkout.new(promotional_rules)
        co.scan(item_1)
        co.scan(item_1)
        co.scan(item_3)
        co
      }
      before { checkout }
      it 'Total price expected: £36.95' do
        expect(checkout.total == 36.95).to be true
      end
    end

    context 'Wish list: 001,001,002,003' do
      let(:checkout){
        co = Checkout.new(promotional_rules)
        co.scan(item_1)
        co.scan(item_1)
        co.scan(item_2)
        co.scan(item_3)
        co
      }
      before { checkout }
      it 'Total price expected: £73.76' do
        expect(checkout.total == 73.76).to be true
      end
    end
  end
end

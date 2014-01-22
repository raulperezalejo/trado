FactoryGirl.define do
    factory :cart do
        ignore do
            cart_item_count 3
        end

        factory :full_cart do
            after(:create) do |cart, evaluator|
                create_list(:cart_item, evaluator.cart_item_count)
            end
        end
    end 
end
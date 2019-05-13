FactoryBot.define do
    factory :user do |u|
        name { "Phoebe" }
        u.sequence(:email) { |n| "phoebe22#{n}@awesome.com"}
        password { "password123" }
        password_confirmation { "password123" }
    end
end

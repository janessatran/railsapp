FactoryBot.define do
    factory :user do |u|
        u.sequence(:name) { |n| "TestUser #{n}" }
        u.sequence(:email) { |n| "tester#{n}@email.com"}
        password { "password123" }
        password_confirmation { "password123" }
    end

    factory :admin_user, class: User do |u|
        name { 'Admin User' }
        u.sequence(:email) { |n| "admin#{n}@email.com"}
        password {'password123'}
        password_confirmation {'password123'}
        admin {true}
    end
end

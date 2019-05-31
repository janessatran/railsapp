FactoryBot.define do
    factory :user do |u|
        u.sequence(:name) { |n| "TestUser #{n}" }
        u.sequence(:email) { |n| "tester#{n}@email.com"}
        password { "password123" }
        password_confirmation { "password123" }
        activated { true }
        activated_at { Time.zone.now }
    end

    factory :admin_user, class: User do |u|
        name { 'Admin User' }
        u.sequence(:email) { |n| "admin#{n}@email.com"}
        password {'password123'}
        password_confirmation {'password123'}
        admin {true}
        activated { true }
        activated_at { Time.zone.now }
    end
end

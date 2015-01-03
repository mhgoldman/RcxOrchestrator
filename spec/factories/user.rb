FactoryGirl.define do
   factory :user do
     sequence(:email, 100) { |n| "person#{n}@example.com" }
     password "estebancolberto"
     password_confirmation "estebancolberto"
     confirmed_at Time.now
   end
 end
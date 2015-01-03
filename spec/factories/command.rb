FactoryGirl.define do
   factory :command do
   	 name "Ping Google DNS"
     description "Just ping it"
     path "C:\\Windows\\System32\\ping.exe"
   end
 end
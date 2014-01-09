# TODO
#
# @author Brendan MacDonell

FactoryGirl.define do
  factory :user do
    full_name "#{Random.firstname} #{Random.lastname}"
    student_number "#{Random.number(950000) + 100000000}"
    programme "Electrical"
    email Random.email
    password Random.alphanumeric
  end
end

# TODO
#
# @author Brendan MacDonell

FactoryGirl.define do
  factory :student, class: User do
    role User::GROUP_MEMBER_ROLE
    full_name "#{Random.firstname} #{Random.lastname}"
    student_number "#{Random.number(950000) + 100000000}"
    programme User::PROGRAMMES.sample
    email Random.email
    password Random.alphanumeric
  end

  factory :coordinator, class: User do
    role User::COORDINATOR_ROLE
    full_name "#{Random.firstname} #{Random.lastname}"
    email Random.email
    password Random.alphanumeric
  end

  factory :supervisor, class: User do
    role User::SUPERVISOR_ROLE
    full_name "#{Random.firstname} #{Random.lastname}"
    email Random.email
    password Random.alphanumeric
  end

  factory :project do
    name Random.alphanumeric
    description Random.paragraphs
  end

end

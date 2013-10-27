namespace :create do

  task :coordinator do
    email = ENV['email'].dup
    name = ENV['name'].dup

    #prompt for password
    puts "Please enter the password for: email=#{email}, name=#{name}"
    password = STDIN.gets.chomp

    user = User.create(email:  email, full_name: name, role: User::COORDINATOR_ROLE, password: password, password_confirmation: password)
    user.save
  end


  task :supervisor => :environment do
    email = ENV['email'].dup
    name = ENV['name'].dup

    #prompt for password
    puts "Please enter the password for: email=#{email}, name=#{name}"
    password = STDIN.gets.chomp

    user = User.create(email:  email, full_name: name, role: User::SUPERVISOR_ROLE, password: password, password_confirmation: password)
    user.save
  end

end

desc "Seed initial data"
task :seed => :environment do
  puts "Creating account..."
  account = Account.create(:name => "Admin", :surname => "Blog", :email => "admin@padrino.org", :role => "admin", :password => "admin", :password_confirmation => "admin")
  if account.valid?
    puts "Account created with email: #{account.email} and password: #{account.password}"
  else
    puts "Account is not valid because: \n  - #{account.errors.collect { |err| err.join("\n  - ") }.join("\n  - ")}"
  end
end
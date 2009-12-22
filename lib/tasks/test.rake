desc 'Demostrate how handle current environment'
task :only => :environment do
  puts Padrino.env
end
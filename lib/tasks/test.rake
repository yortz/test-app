desc 'Demostrate how handle current environment'
task :env => :environment do
  puts Padrino.env
end
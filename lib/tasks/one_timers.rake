namespace :one_timers do

  desc "populate data"
  task :populate_data => :environment do
    pp "Creating Users"
    User.create(id: 1,name: "Neeraj")
    User.create(id: 2,name: "Ravi")
    User.create(id: 3,name: "Arun")

    Trip    
  end

end
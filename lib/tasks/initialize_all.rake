namespace :init_task do
  desc "Do all initialization tasks"
  task :all => :environment do
    Rake::Task["init_task:re_seed"].execute
    Rake::Task["init_task:truncate_wirelog"].execute
  end

  desc "Reseed TC and TP"
  task :re_seed  => :environment do
    puts "cleaning db tables..."
    Lti2Tp::Registration.delete_all
    LtiRegistrationWip.delete_all
    Tenant.delete_all
    Iresource.delete_all

    puts "load..."
    tp_path = Rails.application.config.tool_consumer_registry.tool_provider_path
    system "cd #{tp_path}; rake db:load"
  end

  desc "Reseed and backup all--assumes current is canonic"
  task :backup  => :environment do
    puts "cleaning db tables..."
    Lti2Tp::Registration.delete_all
    LtiRegistrationWip.delete_all
    Tenant.delete_all
    Iresource.delete_all

    puts "load..."
    system "rake db:load"

    puts "copy sqlite3 to closet/backups..."
    system "cp db/development.sqlite3 data/tpsampleapp.sqlite3"
  end

  desc "Truncate the wirelog"
  task :truncate_wirelog => :environment do
    wire_log_file = File.truncate(Rails.application.config.wire_log.output_file_name, 0)
  end
end

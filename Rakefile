require File.join(File.dirname(__FILE__), "config", "boot")

namespace :db do
  desc "Initialize the database"
  task :init do
    DataMapper.auto_migrate!
  end

  desc "Update the database"
  task :update do
    DataMapper.auto_upgrade!
  end
end

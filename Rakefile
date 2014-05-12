namespace :db do
  task :sequel do
    begin
      require 'dotenv'
      Dotenv.load
    rescue LoadError
      # skip
    end
    require "sequel"
    Sequel.extension :migration
    DB = Sequel.connect(ENV['DATABASE_URL'])
  end

  desc "Prints current schema version"
  task :version => :sequel do
    version = if DB.tables.include?(:schema_info)
                DB[:schema_info].first[:version]
              end || 0

    puts "Schema Version: #{version}"
  end

  desc "Perform migration up to latest migration available"
  task :migrate => :sequel do
    Sequel::Migrator.run(DB, "db/migrate")
    Rake::Task['db:version'].execute
  end
end
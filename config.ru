require_relative 'boot'

db = Sequel.connect(ENV['DATABASE_URL'])
ClickerApp.sessions_repository = SessionRepository.new(db)
run ClickerApp
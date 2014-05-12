require_relative 'boot'

ClickerApp.sessions_repo = SessionRepo.new(PubSub.new)

run ClickerApp
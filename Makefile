.PHONY: help install setup db-setup db-migrate db-seed server cron import open test lint

help: ## Show this help
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

install: ## Install project dependencies
	bundle install

setup: install db-setup db-migrate db-seed ## Complete project setup

db-setup: ## Setup database users and permissions
	bundle exec rails db:create

db-migrate: ## Run database migrations
	bundle exec rails db:migrate

db-seed: ## Seed the database
	bundle exec rails db:seed

server: ## Start the Rails server
	bundle exec rails server

cron: ## Setup cron jobs for event imports
	bundle exec whenever --update-crontab

import: ## Import events manually
	bundle exec rake explore:go

open: ## Open the application in the default browser
	start http://localhost:3000/

test: ## Run the test suite
	bundle exec rspec

test-watch: ## Run tests automatically on file changes
	bundle exec guard

test-coverage: ## Run tests with coverage report
	COVERAGE=true bundle exec rspec

lint: ## Run Rubocop linting
	bundle exec rubocop

lint-fix: ## Auto-fix Rubocop issues when possible
	bundle exec rubocop -a

console: ## Start Rails console
	bundle exec rails console

routes: ## Display all routes
	bundle exec rails routes

clean: ## Clean temporary files and logs
	bundle exec rails log:clear tmp:clear

reset-db: ## Reset and reseed database
	bundle exec rails db:drop db:create db:migrate db:seed

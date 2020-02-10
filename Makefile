bold=$(shell (tput bold))
normal=$(shell (tput sgr0))
.DEFAULT_GOAL=help
DISTRIB:=$(shell lsb_release -is | tr '[:upper:]' '[:lower:]')
VERSION:=$(shell lsb_release -cs)
ARCHITECTURE:=$(shell dpkg --print-architecture)

help:
	@echo "${bold}install${normal}\n\t Installs the whole appplication.\n"
	@echo "${bold}uninstall${normal}\n\t Stops and removes all containers and drops the database.\n"
	@echo "${bold}start${normal}\n\t Starts the application.\n"
	@echo "${bold}db.connect${normal}\n\t Connects to the database.\n"
	@echo "${bold}phpunit.run${normal}\n\t Runs the unit tests.\n"

start:
	docker-compose up --build -d
	sleep 3

stop:
	docker-compose down -v
	docker-compose rm -v

install: uninstall start db.install

uninstall: stop
	@sudo rm -rf postgres-data error.log

reinstall: install

#Connects to the databatase
db.connect:
	sleep 3
	docker-compose exec postgres /bin/bash -c 'psql -U $$POSTGRES_USER'

db.install:
	docker-compose exec postgres /bin/bash -c 'psql -U $$POSTGRES_USER -h localhost -f data/db.sql'


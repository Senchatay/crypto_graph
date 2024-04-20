build:
	docker-compose build
start:
	docker-compose up
debug:
	docker-compose run --rm -p 3000:3000 app ash -c 'ruby app/main.rb'
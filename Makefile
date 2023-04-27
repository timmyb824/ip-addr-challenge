pip-compile:
	pip install pip-tools pip-autoremove

compile-deps:
	pip-compile -o requirements.txt pyproject.toml

compile-dev-deps:
	pip-compile --extra dev -o requirements-dev.txt pyproject.toml

install-deps:
	pip install -r requirements.txt

install-dev-deps:
	pip install -r requirements-dev.txt

run-app:
	gunicorn src.main:app -w 2 --threads 2 -b 0.0.0.0:5001 --reload

run-app-docker:
	docker-compose up -d --force-recreate --build

docker-build:
	docker build -t timmyb824/ip-addr-challenge:${TAG} .

docker-tag:
	docker tag timmyb824/ip-addr-challenge:${TAG} timmyb824/ip-addr-challenge:latest

# docker push timmyb824/ip-addr-challenge:tagname
docker-push:
	docker push timmyb824/ip-addr-challenge:${TAG}

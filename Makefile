pip-compile:
	pip install pip-tools pip-autoremove

compile-deps:
	pip-compile --resolver=backtracking -o requirements.txt pyproject.toml

compile-dev-deps:
	pip-compile --resolver=backtracking --extra dev -o requirements-dev.txt pyproject.toml

install-deps:
	pip install -r requirements.txt

install-dev-deps:
	pip install -r requirements-dev.txt

run-app:
	gunicorn --config ./configs/gunicorn_config.py src.main:app --reload

run-app-docker:
	docker-compose up -d --force-recreate --build

# for M1 Mac use TAG=latest-arm64v8
docker-build:
	docker build -t timmyb824/ip-addr-challenge:${TAG} .

docker-tag:
	docker tag timmyb824/ip-addr-challenge:${TAG} timmyb824/ip-addr-challenge:${TAG}

# docker push timmyb824/ip-addr-challenge:tagname
docker-push:
	docker push timmyb824/ip-addr-challenge:${TAG}

# provider can be AWS or Proxmox
terraform-init:
	cd deploy/terraform/$(PROV) && terraform init

terraform-plan:
	cd deploy/terraform/$(PROV) && terraform plan

deploy-vm:
	cd deploy/terraform/$(PROV) && terraform init && terraform apply -auto-approve

destroy-vm:
	cd deploy/terraform/$(PROV) && terraform destroy -auto-approve

configure-vm:
	cd deploy/ansible && ansible-playbook -i inventory.ini playbook.yaml

deploy-configure:
	make deploy-vm PROV=$(PROV)
	sleep 60
	make configure-vm

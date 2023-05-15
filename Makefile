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
	gunicorn --config ./configs/gunicorn.config.py src.main:app --reload

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
	cd deploy/$(VERSION)/terraform/$(PROV) && terraform init

terraform-plan:
	cd deploy/$(VERSION)/terraform/$(PROV) && terraform plan

terraform-apply:
	cd deploy/$(VERSION)/terraform/$(PROV) && terraform init && terraform apply -auto-approve

destroy-vm:
	cd deploy/$(VERSION)/terraform/$(PROV) && terraform destroy -auto-approve

configure-vm:
	cd deploy/$(VERSION)/ansible && ansible-playbook -i inventory.ini playbook.yaml

deploy-complex:
	make terraform-apply VERSION=complex PROV=$(PROV)
	sleep 30
	make configure-vm VERSION=complex

deploy-simple:
	rm -f src/logs/app.json
	cd deploy/simple/terraform/aws && terraform init && terraform apply -auto-approve
	sleep 30
	cd deploy/simple/ansible && ansible-playbook -i inventory.ini playbook.yaml

destroy-simple:
	cd deploy/simple/terraform/aws && terraform destroy -auto-approve

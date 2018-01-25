# Install Project Dependencies
install:
	pip install -r requirements.txt

# Run Project Unit Tests
test:
	python app/tests/test_dummies.py

# Build Staging Image
build_stg:
	sudo docker build -t staging .

# Build Production Image
build_prod:
	sudo docker build -t prod .

# Tag & Push Staging Image
tag_stg:
	sudo docker tag staging:latest 984084214586.dkr.ecr.us-east-1.amazonaws.com/staging:latest
	sudo docker push 984084214586.dkr.ecr.us-east-1.amazonaws.com/staging:latest

# Tag & Push Production Image
tag_prod:
	sudo docker tag prod:latest 984084214586.dkr.ecr.us-east-1.amazonaws.com/prod:latest
	sudo docker push 984084214586.dkr.ecr.us-east-1.amazonaws.com/prod:latest

deploy_stg:
	ansible-playbook -i ansible/hosts ansible/staging.yaml

deploy_prod:
	ansible-playbook -i ansible/hosts ansible/production.yaml

# Terraform
vars:
	cp infrastructure/terraform.tfvars.template infrastructure/terraform.tfvars

plan:
	cd infrastructure/ && terraform plan

apply:
	cd infrastructure/ && terraform apply

destroy:
	cd infrastructure/ && terraform destroy

# Install Project Dependencies
install:
	pip install -r requirements.txt

# Run Project Unit Tests
test:
	cd app && nosetests -v

# Build Staging Image
build_stg:
	docker build -t staging .

# Build Production Image
build_prod:
	docker build -t prod .

# Tag & Push Staging Image
tag_stg:
	docker tag staging:latest 984084214586.dkr.ecr.us-east-1.amazonaws.com/staging:latest
	docker push 984084214586.dkr.ecr.us-east-1.amazonaws.com/staging:latest

# Tag & Push Production Image
tag_prod:
	docker tag prod:latest 984084214586.dkr.ecr.us-east-1.amazonaws.com/prod:latest
	docker push 984084214586.dkr.ecr.us-east-1.amazonaws.com/prod:latest

deploy_stg:
	ansible-playbook -i ansible/hosts ansible/staging.yaml

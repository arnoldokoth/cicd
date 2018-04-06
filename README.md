#  CI/CD
## Infrastructure
This repo is a sample CI/CD pipeline created for the purposes of assessment. The setup contains infrastructure scripts written in terraform to create the required resources on AWS. When run, the terraform scripts create two load balancers one for staging and the other for production. It also creates four servers and attaches them to the load balancers, two for production and two for staging.

The setup also deploys a Jenkins build server on Amazon Linux. However, the build server requires a bit of manual setup to complete the Jenkins installation. Also setting up the SSH agent with the instances key pair to allow Ansible to connect and run the play books from the deployment server.

### Creating Infrastructure
To create the environment you will need to add AWS access keys to `terraform.tfvars` in the infrastructure folder. You can copy the template onto the required file by running:
```
make vars
```
Then replace the contents of the newly created file with the necessary AWS IAM keys preferrably for a user with Administrator privileges to allow terraform to create a wide range of resources.

After completing this, you can run `make plan` to allow Terraform to come up with an execution plan with the resources that need to be created or altered if this is not your first run.

This is then followed by running `make apply` to create and deploy the resources in your AWS environment.

The resources can also be destroyed using `make destroy` when no longer required.

## Docker
The application in this setup is a basic Flask application. It contains two basic routes and basic unit tests that verify that the routes work as expected. The application is deployed using a Docker container onto our EC2 instances in this setup.

## Ansible
We use Ansible in this setup to update the currently running image on the instances whenever a deployment is triggered. The Ansible Play Books ensure that Docker is installed on the servers on which we need to deploy our instances to.

## The Pipeline
The implemented pipeline relies heavily on version control and branching. Though it might not be the best approach, the pipeline can be enhanced by introducing tagging which may require a final manual step to version the tag using semantic versioning and add release notes to the specified tag. Also since the application is deployed using Docker, we can enhance it by tagging our images using the same versioning process.

### Testing
The first step run in the pipeline as defined in the `Jenkinsfile` is the creation of the virtual environment and installation of the dependencies in the `requirements.txt` file. After successful installation, the pipeline goes ahead to run the tests.

### Image Build
Depending on the branch upon which changes have been made, this step goes ahead and builds a Docker image for the environment associated to that branch. In our case, if the branch is `develop` it builds an image for the staging environment, and if it's `master` it builds an image for the production environment.

### Image Tag & Push
Following the image build, our image is tagged and pushed to Amazon ECR. The instances are assigned IAM roles with ECR permissions to allow them to push and pull the images to and from ECR.

### Deploy
The deploy process then follows by running the Ansible playbooks for the specified environments to pull the latest Docker image from ECR and run it on our instances.

## Proposed Enhancements
The pipeline can be improved by adding a notification mechanism to stakeholders after each step, when a step fails or after the entire pipeline has run. This can be done using the Jenkins Slack Plugin to send a notification to a Slack channel.

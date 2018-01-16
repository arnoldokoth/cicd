node {

    stage('Create Virtual Environment & Install Requirements') {
        checkout scm
        sh 'virtualenv test'
        sh 'source test/bin/activate'
        sh 'pip install -r requirements.txt'
    }

    stage('Test') {
        sh 'make test'
    }

    stage('Build Docker Image') {
        if (env.BRANCH_NAME == 'develop') {
            sh 'make build_stg'
        }
        else if (env.BRANCH_NAME == 'master') {
            sh 'make build_prod'
        }
    }

    stage('Tag & Push Docker Image') {
        if (env.BRANCH_NAME == 'develop') {
            sh 'make tag_stg'
        }
        else if (env.BRANCH_NAME == 'master') {
            sh 'make tag_prod'
        }
    }

    stage('Deploy Image') {
        if (env.BRANCH_NAME == 'develop') {
            sh 'make deploy_stg'
        }
        else if (env.BRANCH_NAME == 'master') {
            sh 'make deploy_prod'
        }
    }
}

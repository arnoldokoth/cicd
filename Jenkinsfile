node {
    checkout scm

    stage('Install Requirements') {
        sh 'pip install -r requirements.txt --user'
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

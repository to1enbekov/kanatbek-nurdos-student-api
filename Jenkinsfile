pipeline {
    agent any

    options { timestamps(); disableConcurrentBuilds() }
    triggers { pollSCM('H/2 * * * *') }

    environment {
        DOCKER_IMAGE = 'kanatbek-nurdos-student-api:v1.0-kanatbek-nurdos'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo 'Student: Kanatbek Nurdos'
                sh 'git rev-parse --short HEAD && git status --short'
            }
        }
        stage('Build') {
            steps {
                sh 'java -version'
                sh 'chmod +x gradlew scripts/setup_gradle_wrapper.sh && ./gradlew --no-daemon clean classes'
            }
        }
        stage('Test') {
            steps {
                sh './gradlew --no-daemon test'
            }
        }
        stage('Docker Build') {
            steps {
                sh 'docker build -t "$DOCKER_IMAGE" .'
            }
        }
        stage('Verify') {
            steps {
                sh 'docker image inspect "$DOCKER_IMAGE" --format "Image: {{.RepoTags}} Size: {{.Size}} bytes"'
                echo 'Pipeline SUCCESS for Kanatbek Nurdos'
            }
        }
    }

    post {
        always { archiveArtifacts artifacts: 'build/test-results/test/*.xml', allowEmptyArchive: true }
        success { echo 'Build and tests passed (Kanatbek Nurdos)' }
        failure { echo 'CI stopped because a stage failed (Kanatbek Nurdos)' }
    }
}

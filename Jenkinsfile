pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                script {
                    docker.image('composer:2.5').inside('-u root') {  // Gunakan versi composer 2.5
                        sh '''
                            composer --version  // Verifikasi versi Composer yang digunakan
                            cp .env.example .env || true
                            rm -f composer.lock
                            composer install --no-interaction --prefer-dist
                        '''
                    }
                }
            }
        }

        stage('Set APP_KEY') {
            steps {
                script {
                    docker.image('php:8.3-cli').inside('-u root') {  // Gunakan PHP versi 8.3
                        sh '''
                            php --version  // Verifikasi versi PHP yang digunakan
                            php artisan key:generate
                        '''
                    }
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    docker.image('php:8.3-cli').inside('-u root') {  // Gunakan PHP versi 8.3
                        sh '''
                            php --version  // Verifikasi versi PHP yang digunakan
                            php artisan test
                        '''
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    docker.image('ubuntu').inside('-u root') {
                        sh 'echo "Deploying Laravel Application"'
                    }
                }
            }
        }
    }
}

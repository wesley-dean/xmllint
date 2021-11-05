pipeline {
    parameters {
        string(
          name: 'repository_url',
          defaultValue: 'https://github.com/wesley-dean/xmllint.git',
          description: 'the URL to the Git repository'
        )

        string(
            name: 'git_credential',
            defaultValue: 'github-wesley-dean',
            description: 'the ID of the credential to use to interact with GitHub'
        )
    }

    environment {
        repository_url = "$params.repository_url"
        git_credential = "$params.git_credential"
        build_time = sh(script: 'date --rfc-3339=seconds', returnStdout: true).trim()
        GROOVY_NPM_GROOVY_LINT_ARGUMENTS = "--noserver"
    }

    triggers {
        cron('@monthly')
    }

    options {
        timestamps()
        ansiColor('xterm')
    }

    agent any
    stages {
        stage('Checkout') {
            steps {
                git branch: 'master',
                credentialsId: git_credential,
                url: repository_url
            }
        }

        stage('Semgrep') {
            agent {
                docker {
                    image 'returntocorp/semgrep'
                    args '--entrypoint=""'
                    reuseNode true
                }
            }

            steps {
                sh "semgrep --config auto --error '${WORKSPACE}'"
            }
        }

        stage('Meta-Linter') {
            agent {
                docker {
                    image 'megalinter/megalinter:latest'
                    args "-e VALIDATE_ALL_CODEBASE=true -v ${WORKSPACE}:/tmp/lint --entrypoint=''"
                    reuseNode true
                }
            }

            steps {
                sh '/entrypoint.sh'
            }
        }
    }
}

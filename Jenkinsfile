
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
        build_time = sh(script: 'date --rfc-3339=seconds',
            returnStdout: true).trim()
        no_proto_repo_url = sh(script: 'echo "${repository_url}" | sed -Ee "s|^https?://||"',
            returnStdout: true).trim()
        GIT_SSH_COMMAND = 'ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
        GROOVY_NPM_GROOVY_LINT_ARGUMENTS = '--no-insight'
        DISABLE_LINTERS = 'SPELL_CSPELL'
        APPLY_FIXES = 'all'
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
                url: "${repository_url}"
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

        stage ('Text File Cleanup') {
            agent {
                docker {
                    image 'cytopia/awesome-ci'
                    reuseNode true
                }
            }

            steps {
                script {
                    def tests = [
                        'file-trailing-single-newline': '--text',
                        'file-trailing-space':          '--text',
                        'file-utf8':                    '--text'
                    ]

                    tests.each() {
                        sh "$it.key $it.value --ignore='.git,.svn' --fix --path='.' || true"
                    }
                }
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

        stage('Push Updated Code') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${git_credential}",
                passwordVariable: 'GIT_PASSWORD',
                usernameVariable: 'GIT_USERNAME')]) {
                    sh 'git commit -nam "Apply fixes from Mega-Linter"'
                    sh 'git push https://${GIT_USERNAME}:${GIT_PASSWORD}@${no_proto_repo_url}'
                }
            }
        }
    }
}

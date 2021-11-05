pipeline {

  parameters {
      string (
        name: 'repository_url',
        defaultValue: 'https://github.com/wesley-dean/xmllint.git',
        description: 'the URL to the Git repository'
      )

    string (
        name: 'git_credential',
        defaultValue: 'github-wesley-dean',
        description: 'the ID of the credential to use to interact with GitHub'
      )
    }

    environment {
        repository_url = "$params.repository_url"
        git_credential = "$params.git_credential"
        build_time = sh(script: "date --rfc-3339=seconds", returnStdout: true).trim()
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
        stage ('Checkout') {
            steps {
                git branch: 'master',
                credentialsId: git_credential,
                url: repository_url
            }
        }


        stage ('Semgrep') {
            agent {
                docker {
                    image 'returntocorp/semgrep'
                    args '--entrypoint=""'
                    reuseNode true
                }
            }

            steps {
                sh 'semgrep --config auto --error "${WORKSPACE}"'
            }
        }


        stage ('Basic File Checks') {
            agent {
                docker {
                    image 'cytopia/awesome-ci'
                    reuseNode true
                }
            }

            steps {
                script {
                    def tests = [
                        'file-trailing-newline': '--text',
                        'file-trailing-space':   '--text',
                        'file-utf8':             '--text',
                        'git-conflicts':         '--text',
                    ]

                    tests.each() {
                        sh "$it.key $it.value --ignore='.git,.svn' --path='.'"
                    }
                }
            }
        }


        stage ('Syntax Checks') {
            agent {
                docker {
                    image 'cytopia/awesome-ci'
                    reuseNode true
                }
            }


            steps {
                script {
                    def tests = [
                        'syntax-bash':     'bash',
                        'syntax-css':      'css',
                        'syntax-js':       'js',
                        'syntax-json':     'json',
                        'syntax-markdown': 'md',
                        'syntax-perl':     'pl',
                        'syntax-php':      'php,phps',
                        'syntax-ruby':     'rb',
                        'syntax-sh':       'sh',
                    ]

                    tests.each() {
                        sh "$it.key --extension=$it.value --ignore='.git,.svn' --path='.'"
                    }
                }
            }
        }


        stage ('Dockerfile Lint') {
            agent {
                docker {
                    image 'hadolint/hadolint:latest-alpine'
                    reuseNode true
                    args '--entrypoint=""'
                }
            }

            steps {
                script {
                    sh 'find . -iname "*dockerfile*" -exec hadolint {} \\;'
                }
            }
        }

        stage ('XML Lint') {
            agent {
                docker {
                    image 'wesley-dean/xmllint:latest'
                    args  '--entrypoint=""'
                    reuseNode true
                }
            }

            steps {
                script {
                    sh '/entrypoint.sh
                }
            }
        }


        stage ('HTML Lint') {
            agent {
                docker {
                    image 'wesley-dean/xmllint:latest'
                    args  '--entrypoint=""'
                    reuseNode true
                }
            }

            environment {
              PATTERN = '**/*.{htm,html}'
            }

            steps {
                script {
                    sh '/entrypoint.sh --html'
                }
            }
        }



        stage ('YAML Lint') {
            agent {
                docker {
                    image 'cytopia/yamllint'
                    reuseNode true
                    args '--entrypoint=""'
                }
            }

            steps {
                script {
                    sh 'yamllint -f colored .'
                }
            }
        }


        stage ('Ansible Lint') {
            agent {
                docker {
                    image 'cytopia/ansible-lint'
                    reuseNode true
                }
            }

            steps {
                script {
                    sh 'if [ -d defaults ] && [ -d tasks ] && [ -d meta ] ; then docker run --rm -v "$(pwd)":"/data/$(basename "$(pwd)" )" -e ANSIBLE_ROLES_PATH="/data" cytopia/ansible-lint "/data/$(basename "$(pwd)" )/tests/test.yml" else true ; fi'
                }
            }
        }


        stage ('Makefile Lint') {
            agent {
                docker {
                    image 'cytopia/checkmake'
                    args  '--entrypoint=""'
                    reuseNode true
                }
            }

            steps {
                script {
                    sh 'find . -name Makefile -exec checkmake {} \\;'
                }
            }
        }


        stage ('Terraform Lint') {
            agent {
                docker {
                    image 'ghcr.io/terraform-linters/tflint-bundle:latest'
                    args  '--entrypoint=""'
                    reuseNode true
                }
            }

            steps {
                script {
                    sh 'tflint'
                }
            }
        }


        stage ('TFSec') {
            agent {
                docker {
                    image 'tfsec/tfsec'
                    args '--entrypoint=""'
                    reuseNode true
                }
            }

            steps {
                script {
                    sh 'tfsec'
                }
            }
        }
    }
}

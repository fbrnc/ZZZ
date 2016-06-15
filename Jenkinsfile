node {

    stage "Checkout"
    deleteDir()

    checkout scm
    // checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/fbrnc/cd-demo-nanoservice.git']]])

    dir('nano-app') {
        stage "Build"
        sh '/usr/local/bin/composer --no-interaction install'

        stage "Static Code Analysis"
        sh '../tests/static/phplint.sh src web > /dev/null'

        stage "Package"
        sh '/usr/local/bin/box build'

        stage "Publish Artifact"
        sh 'aws s3 cp hitcounter.phar s3://aoeplay-artifacts/hitcounter/${BUILD_NUMBER}/hitcounter.phar'
    }

    stage 'Unit Tests'
    dir('tests/unit') {
        sh '/usr/local/bin/phpunit --log-junit /tmp/junit.xml'
    }

    withEnv(["Environment=stage"]) {
        input "Deploy to ${Environment}?"
        stage "Deploy to ${Environment}"
        echo "Deploying to ${Environment}"
    }

    withEnv(["Environment=prod"]) {
        input "Deploy to ${Environment}?"
        stage "Deploy to ${Environment}"
        echo "Deploying to ${Environment}"
    }

}

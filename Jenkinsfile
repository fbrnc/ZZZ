node {

    stage "Checkout"
    deleteDir()
    sh "mkdir artifacts"

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
        sh 'aws s3 cp ../artifacts/hitcounter.phar s3://aoeplay-artifacts/hitcounter/${BUILD_NUMBER}/hitcounter.phar'
        step([$class: 'ArtifactArchiver', artifacts: '../artifacts/hitcounter.phar', fingerprint: true])
    }

    stage 'Unit Tests'
    dir('tests/unit') {
        sh "/usr/local/bin/phpunit --log-junit ../../artifacts/junit.xml"
        step([$class: 'JUnitResultArchiver', testResults: '../../artifacts/junit.xml'])
    }

    withEnv(["Environment=stage"]) {
        stage "Deploy to ${env.Environment}", concurrency: 1
        timeout(time: 10, unit: 'MINUTES') {
            input "Proceed with deploying to ${env.Environment}?"
        }
        echo "Deploying to ${env.Environment}"
    }

    withEnv(["Environment=prod"]) {
        stage "Deploy to ${env.Environment}", concurrency: 1
        timeout(time: 10, unit: 'MINUTES') {
            input "Proceed with deploying to ${env.Environment}?"
        }
        echo "Deploying to ${env.Environment}"
    }

}

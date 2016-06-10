node {

    stage "Checkout"
    deleteDir()

    checkout scm
    // checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/fbrnc/cd-demo-nanoservice.git']]])

    sh '/usr/local/bin/composer --no-interaction install'

    stage "Static Code Analysis"
    sh 'test/static/phplint.sh src web > /dev/null'

    stage "Package"
    sh '/usr/local/bin/box.phar build'

    stage "Publish Artifact"
    sh 'aws s3 cp hitcounter.phar s3://aoeplay-artifacts/hitcounter/${BUILD_NUMBER}/hitcounter.phar'

    stage 'Unit Tests'
    dir('test/unit') {
        sh '/usr/local/bin/phpunit --log-junit /tmp/junit.xml'
    }
    
}

stage "Build"
node {
    deleteDir()

    checkout scm
    // checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/fbrnc/cd-demo-nanoservice.git']]])

    sh '/usr/local/bin/composer --no-interaction install'

    sh 'tar -czf /tmp/build.tar.gz .'

    sh 'aws s3 cp /tmp/build.tar.gz s3://aoeplay-artifacts/hitcounter/${BUILD_NUMBER}/build.tar.gz'

    archive '/tmp/build.tar.gz'
}

stage 'Unit Tests'
node {
    dir('test/unit') {
        sh '/usr/local/bin/phpunit --log-junit /tmp/junit.xml'
    }
}

stage 'Deploy to tst'

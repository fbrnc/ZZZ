node {

    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {

        stage "Checkout"
        deleteDir()

        checkout scm
        // checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/fbrnc/cd-demo-nanoservice.git']]])

        sh "rm -rf artifacts ; mkdir artifacts"

        dir('nano-app') {
            stage "Build"
            sh '/usr/local/bin/composer --ansi --no-progress --no-interaction install'

            stage "Static Code Analysis"
            sh '../tests/static/phplint.sh src web > /dev/null'

            stage "Package"
            sh '/usr/local/bin/box build'
            step([$class: 'ArtifactArchiver', artifacts: 'artifacts/hitcounter.phar', fingerprint: true])

            //stage "Publish Artifact"
            //sh 'aws s3 cp ../artifacts/hitcounter.phar s3://aoeplay-artifacts/hitcounter/${BUILD_NUMBER}/hitcounter.phar'
        }


    }

}

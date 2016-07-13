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

            stage "Publish Artifact"
            sh 'aws s3 cp ../artifacts/hitcounter.phar s3://aoeplay-artifacts/hitcounter/${BUILD_NUMBER}/hitcounter.phar'
        }
        step([$class: 'ArtifactArchiver', artifacts: 'artifacts/hitcounter.phar', fingerprint: true])

        stage 'Docker'
        sh '$(aws ecr get-login --region us-west-2)'
        sh "docker build -t 443171610680.dkr.ecr.us-west-2.amazonaws.com/nano:${env.BUILD_NUMBER} ."
        sh "docker push 443171610680.dkr.ecr.us-west-2.amazonaws.com/nano:${env.BUILD_NUMBER}"

        stage 'Unit Tests'
        dir('tests/unit') {
            sh "/usr/local/bin/phpunit --colors --log-junit ../../artifacts/junit.xml"
        }
        step([$class: 'JUnitResultArchiver', testResults: 'artifacts/junit.xml'])

        stage "Prepare Infrastructure code"
        dir('infrastructure') {
            sh '/usr/local/bin/composer --ansi --no-dev --no-progress --no-interaction install'
        }

        withEnv(["Environment=tst", "DEPLOY_ID=${env.BUILD_NUMBER}", "AWS_DEFAULT_REGION=us-west-2", "USE_INSTANCE_PROFILE=1"]) {
            dir('infrastructure') {
                stage name: "Deploy to ${env.Environment}", concurrency: 1
                // timeout(time: 10, unit: 'MINUTES') {
                //     input "Proceed with deploying to ${env.Environment}?"
                // }
                echo "Deploying to ${env.Environment}"
                sh "bin/stackformation.php blueprint:deploy --ansi --deleteOnTerminate 'demo-env-{env:Environment}-deploy{env:DEPLOY_ID}' || echo 'Stackformation deployment failed'"
                sh "bin/stackformation.php stack:timeline 'demo-env-${env.Environment}-deploy${env.DEPLOY_ID}' > ../artifacts/timeline_${env.Environment}.html"
            }
            publishHTML(target: [reportDir: 'artifacts', reportFiles: "timeline_${env.Environment}.html", reportName: "Deploy Timeline for ${env.Environment}"])

            stage name: "Integration test ${env.Environment}", concurrency: 1
            sh "bash -x tests/integration/integration_test.sh http://api-${env.Environment}.aoeplay.net/"

            stage name: "Stress testing ${env.Environment}", concurrency: 1
            sh "bash tests/stress/stress_test.sh http://api-${env.Environment}.aoeplay.net/"
        }

        echo "Done"
    }

}

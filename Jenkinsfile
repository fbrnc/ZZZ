node {

    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {

        stage "Checkout"
        deleteDir()

        checkout scm
        // checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/fbrnc/cd-demo-nanoservice.git']]])

        sh "rm -rf artifacts ; mkdir artifacts"

        echo "Done"
    }

}

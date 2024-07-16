pipeline {
    agent {
        label 'rbhe'
    }
    stages {
        stage('SDLE Upload') {
            when {
                anyOf {
                    allOf {
                        expression { env.GIT_BRANCH == 'main' }
                        expression { common.isSdleUploadCommit() }
                    }
                    triggeredBy 'UserIdCause'
                }
            }
            steps {
                script {
                    parallel getStages('sdle.yaml')
                }
            }
        }
    }
    post {
        cleanup {
            cleanWs()
        }
    }
}

def getStages(filename) {
    def projects = readYaml file: filename
    def stages = projects.collectEntries {
        ["${it.repo}" : generateStage(it)]
    }
    stages
}

def generateStage(project) {
    return {
        stage("${project.repo}") {
            // ensure isolated workspace for each project
            ws {
                sh 'rm -rf artifacts/'

                downloadGHArtifacts([
                    projectOwner: project.owner,
                    projectRepo: project.repo,
                    projectBranch: project.branch,
                    projectArtifacts: project.artifacts,
                    projectFolders: project.folders])

                sdleUpload([
                   sdleUploadProjectId: project.sdle_project_id])
            }
        }
    }
}
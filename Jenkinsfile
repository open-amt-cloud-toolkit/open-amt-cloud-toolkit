pipeline {
    agent {
        label 'rbhe'
    }
    triggers {
        // execute @ 9:30 AM on Jan 15, Apr 15, Jul 15, Oct 15
        cron('TZ=US/Arizona\n30 9 15 1,4,7,10 *')
    }
    stages {
        stage('SDLE Upload') {
            when {
                anyOf {
                    allOf {
                        expression { env.GIT_BRANCH == 'main' }
                        triggeredBy 'TimerTrigger'
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
        ["${it}" : generateStage(it)]
    }
    stages
}

def generateStage(project) {
    return {
        stage("${project.name}") {
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
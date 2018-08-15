
// Basic test of the pipeline script, everything under this 'node' runs on the 
// Linux CI controller
node {
   stage("init") {
      echo 'Hello World'
   }
   stage("checkout") {
      checkout scm
   }
   // Shows basic functionality of running a script on the CI controller.
   // Execution of stages/steps always happens inside the Jenkins workspace, denoted
   // by the environment variable WORKSPACE (in this case, it isn't needed since WORKSPACE
   // is the cwd anyways, just put here for illustration
   stage("runscript") {
      sh "chmod 777 ${WORKSPACE}/*.sh" 
      sh "${WORKSPACE}/hello.sh"
   }
}

// Describes a new stage, stages are executed in the order in which they are declared
// so this currently executes as the fourth stage
stage("vmagent_build") {
   // Providing a string argument to node() causes the steps inside to be executed on
   // machines of a given label. This is currently configured to be a VisualStudio2017
   // VM allocated on Azure
   node("azwincr") {
      checkout scm     // Checkout the source, and...
      bat 'build.bat'  // Run the checked in build script.
      // 'stash' the results (in this case the built .exe) to a label 'tests' which subsequent
      // stages/steps can reference by name. Note this is different than archiving.
      stash include:'**/*.exe', name:'tests'
   }
}

def test_shards = [:]

def test_sets = readJSON text: '''
    [{
        "name" : "test_set_1",
        "shards" : 10,
        "command" : "echo set_1 ${index} & hello.exe"
    },
    {
        "name" : "test_set_noshard",
        "command" : "echo set_noshard ${index} & hello.exe"
    },
    {
        "name" : "test_set_2",
        "shards" : 20,
        "command" : "echo set_2 ${index} & hello.exe"
    }]
'''

for (record in test_sets) {
    def recForClosure = record
    if (record.shards) {
        for (int i = 0; i < record.shards; i++) {
            def index = i //if we tried to use i below, it would equal 4 in each job execution.
            test_shards["${record.name}.${i}"] = {
                stage("vmagent_test${recForClosure.name}.${index}") {
                    node("azwintest") {
                        // unpack the stashed results ('tests') and run them
                        //unstash name:'tests'
                        bat recForClosure.command + " ${index}/${recForClosure.shards}"
                    }
                }
            }
        }
    }
    else {
        test_shards["${record.name}"] = {
            stage("vmagent_test${recForClosure.name}") {
                node("azwintest") {
                    unstash name:'tests'
                    bat recForClosure.command
                }
            }
        }
    }
}

stage("echoer") { node("azwintest") {
    bat "echo ${test_shards}"
}}

parallel test_shards

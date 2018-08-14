
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

parallel(
  "test1" : {
    // This stage doesn't run until after the build stage above
    stage("vmagent_test1") {
        // This stage runs on a different label - test VMs
        node("azwintest") {
            // unpack the stashed results ('tests') and run them
            unstash name:'tests'
            bat 'echo 1 & hello.exe'
        }
    }
  },
  "test2" : {
    stage("vmagent_test2") {
        // This stage runs on a different label - test VMs
        node("azwintest") {
            // unpack the stashed results ('tests') and run them
            unstash name:'tests'
            bat 'echo 2 & hello.exe'
        }
    }
  }
)

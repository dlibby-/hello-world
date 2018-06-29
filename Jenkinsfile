node {
   stage("init") {
      echo 'Hello World'
   }
   stage("checkout") {
      checkout scm
   }
   stage("runscript") {
      sh "chmod 777 ${WORKSPACE}/*.sh" 
      sh "${WORKSPACE}/hello.sh"
   }
}

stage("vmagent_build") {
   node("azwinvs") {
      checkout scm
      bat 'build.bat'
      stash include:'**/*.exe', name:'tests'
   }
}

stage("vmagent_test") {
  node("azwin") {
    unstash name:'tests'
    bat 'hello.exe'
  }
}

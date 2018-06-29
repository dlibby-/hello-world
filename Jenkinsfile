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

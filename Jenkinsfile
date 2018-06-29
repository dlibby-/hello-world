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

stage("vmagent_exec") {
   node("azwinbuild") {
      checkout scm
      bat 'dir /s'
      bat 'build.bat'
   }
}

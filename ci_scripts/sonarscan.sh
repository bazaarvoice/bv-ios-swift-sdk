wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.6.2.2472-linux.zip
unzip sonar-scanner-cli-4.6.2.2472-linux.zip

./sonar-scanner-4.6.2.2472-linux/bin/sonar-scanner \
 -Dsonar.host.url=$SONAR_URL \
 -Dsonar.login=$SONAR_LOGIN \
 -Dsonar.coverageReportPaths=sonarqube-generic-coverage.xml

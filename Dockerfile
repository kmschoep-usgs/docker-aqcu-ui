FROM tomcat:8.0-jre8

MAINTAINER Ivan Suftin <isuftin@usgs.gov>

EXPOSE 8080

RUN wget -O /usr/local/tomcat/webapps/aqcu-ui.war "http://cida-eros-maven-public.er.usgs.gov:8080/maven/service/local/artifact/maven/redirect?r=cida-public-releases&g=gov.usgs.aqcu&a=aqcu-ui&v=1.9&e=war"

RUN wget -O /usr/local/tomcat/webapps/probe.war "https://github.com/psi-probe/psi-probe/releases/download/3.0.0.M3/probe.war"

RUN mkdir -p /usr/local/tomcat/ssl

RUN keytool -genkey -noprompt -keystore /usr/local/tomcat/ssl/.keystore -validity 999 -keysize 2048 -alias aqcu-ui -keyalg RSA -keypass changeit -storepass changeit -dname "CN=aqcu-ui, OU=owi, O=owi, L=middleton, S=WI, C=US" 

RUN keytool -selfcert -alias aqcu-ui -keypass changeit -dname "CN=aqcu-ui, OU=owi, O=owi, L=middleton, S=WI, C=US" -keystore /usr/local/tomcat/ssl/.keystore -storepass changeit -validity 999

COPY server.xml /usr/local/tomcat/conf/server.xml

COPY context.xml /usr/local/tomcat/conf/context.xml

COPY tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml

COPY setenv.sh /usr/local/tomcat/bin/setenv.sh 

RUN chmod +x /usr/local/tomcat/bin/setenv.sh
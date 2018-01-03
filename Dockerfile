#######################################################################
# Creates a base Ubuntu image with Tomcat 8.5.24                      #
#######################################################################

# Use the Ubuntu base image
FROM ubuntu

# Update the system
RUN apt-get -y update;apt-get clean all

##########################################################
# Install Java JDK
##########################################################
RUN apt-get -y install wget && \
    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/jdk-8u151-linux-x64.tar.gz && \
    mkdir /usr/java && \
    tar -zxvf jdk-8u151-linux-x64.tar.gz -C /usr/java && \
    apt-get -y remove wget && \
    rm -f jdk-8u151-linux-x64.tar.gz

ENV JAVA_HOME /usr/java/jdk1.8.0_151

##########################################################
# Create tomcat user
##########################################################

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd tomcat && useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat

############################################
# Install Tomcat 8.5.24
############################################
RUN apt-get -y install curl
RUN curl -O http://www-us.apache.org/dist/tomcat/tomcat-8/v8.5.24/bin/apache-tomcat-8.5.24.tar.gz
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.3/gosu-amd64" \
&& chmod +x /usr/local/bin/gosu

RUN mkdir /opt/tomcat
RUN tar -xzvf apache-tomcat-8.5.24.tar.gz -C /opt/tomcat --strip-components=1
RUN chown -hR tomcat:tomcat /opt/tomcat

#chmod -R g+r /opt/tomcat/conf && \
#chmod g+x /opt/tomcat/conf && \
#chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/

##########################################################
# Allow firewall
##########################################################
#RUN ufw allow 8080

##########################################################
# Replace the systemd service, users and context files
##########################################################
RUN rm /opt/tomcat/conf/tomcat-users.xml /opt/tomcat/webapps/host-manager/META-INF/context.xml /opt/tomcat/webapps/manager/META-INF/context.xml

COPY tomcat.service /etc/systemd/system/
COPY tomcat-users.xml /opt/tomcat/conf/
COPY host-manager-context.xml /opt/tomcat/webapps/host-manager/META-INF/context.xml
COPY manager-context.xml /opt/tomcat/webapps/manager/META-INF/context.xml

#RUN systemctl daemon-reload
#RUN systemctl enable tomcat

##########################################################
# Clean up
##########################################################
RUN rm -f apache-tomcat-8.5.24.tar.gz

############################################
# Expose paths and start Tomcat
############################################
EXPOSE 22 8080 8443

COPY docker-entrypoint.sh /
RUN chmod 700 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

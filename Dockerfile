FROM tomcat:9.0-alpine

LABEL maintainer="declan.lynch@dcsg.com"

EXPOSE 5200 5100

ENV CODEBASE_URL file:/root/Protege_3.5/protege.jar
ENV EAM_VERSION 615

# Install some tools
RUN apk update
RUN apk add ca-certificates wget graphviz
RUN update-ca-certificates

# Install Protege Server
RUN wget --tries=3 --progress=bar:force:noscroll https://essential-cdn.s3.eu-west-2.amazonaws.com/protege/install_protege_3.5-Linux64-noJVM.bin
COPY support/protege-response.txt ./
RUN chmod u+x install_protege_3.5-Linux64-noJVM.bin
RUN ./install_protege_3.5-Linux64-noJVM.bin -i console -f protege-response.txt
RUN rm protege-response.txt 
RUN rm install_protege_3.5-Linux64-noJVM.bin 

# Install EssentialEAM Installer
RUN wget --tries=3 --progress=bar:force:noscroll https://essential-cdn.s3.eu-west-2.amazonaws.com/essential-widgets/essentialinstallupgrade67.jar
COPY support/auto-install.xml ./
RUN java -jar essentialinstallupgrade67.jar auto-install.xml

# Install Essential View and Import Utilities
RUN wget --tries=3 --progress=bar:force:noscroll https://essential-cdn.s3.eu-west-2.amazonaws.com/viewer/essential_viewer_6181.war
RUN wget --tries=3 --progress=bar:force:noscroll https://essential-cdn.s3-eu-west-2.amazonaws.com/import-utility/essential_import_utility_27.war
RUN mv essential_viewer_6181.war /usr/local/tomcat/webapps/essential_viewer.war
RUN mv essential_import_utility_27.war /usr/local/tomcat/webapps/essential_import_utility.war

# Copy data & startup scripts
COPY server/* /opt/essentialAM/server/
COPY repo/* /opt/essentialAM/
COPY support/startup.sh /
COPY support/run_protege_server_fix.sh /

# Setup Environment
ENV CATALINA_OPTS="-Xms1G -Xmx2G"
ENV JAVA_HOME /usr/lib/jvm/default-jvm
WORKDIR /root/Protege_3.5/

# Set Execute Permissions on scripts
RUN chmod +x /startup.sh
RUN chmod +x /run_protege_server_fix.sh


# Startup the services
CMD ["/startup.sh"]

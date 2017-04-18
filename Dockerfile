FROM ubuntu
MAINTAINER Dmitry Garin

#install mongodb
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10 && \
	echo "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen" | tee -a /etc/apt/sources.list.d/10gen.list && \
	apt-get update && \
	apt-get -y install apt-utils && \
	apt-get -y install mongodb-10gen

EXPOSE 27017

#install redis
RUN apt-get update && \
    apt-get install --no-install-recommends -y redis-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    update-rc.d -f redis-server disable && \
    sed -i 's/^\(bind .*\)$/# \1/' /etc/redis/redis.conf && \
    sed -i 's/^\(daemonize .*\)$/# \1/' /etc/redis/redis.conf

EXPOSE 6379

# install Java
RUN apt-get update -y && \
	apt-get install software-properties-common python-software-properties -y
RUN add-apt-repository ppa:webupd8team/java -y && \
	apt-get update -y && \
	echo "yes" | apt-get install oracle-java8-installer -y
RUN	echo "1" | update-alternatives --config java && \
	echo "JAVA_HOME=\"/usr/lib/jvm/java-8-oracle/jre\"" >> /etc/environment
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle/jre
ENV PATH $JAVA_HOME/bin:$PATH 

#install Tomcat
RUN groupadd tomcat && \
	useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat && \
	cd /opt/
COPY tomcat /opt/tomcat
RUN chown -hR tomcat:tomcat /opt/tomcat && \
	chmod +x /opt/tomcat/bin/* && \
	mkdir /opt/tomcat/logs
ENV CATALINA_HOME /opt/tomcat
WORKDIR $CATALINA_HOME

EXPOSE 8080

#install filebeat
RUN cd /tmp && \
	apt-get install curl -y && \
	curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.2.0-amd64.deb && \
	dpkg -i filebeat-5.2.0-amd64.deb 

COPY startscript.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/startscript.sh

CMD ["/usr/local/bin/startscript.sh"]



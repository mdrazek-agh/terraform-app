FROM tomcat
WORKDIR webapps
RUN curl -O https://tomcat.apache.org/tomcat-5.5-doc/appdev/sample/sample.war
CMD ["catalina.sh", "run"]
EXPOSE 8080

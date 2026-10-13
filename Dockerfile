FROM tomcat:9.0-jdk17-temurin

RUN rm -rf /usr/local/tomcat/webapps/*

COPY . /usr/local/tomcat/webapps/ROOT/

COPY entrypoint.sh /usr/local/tomcat/entrypoint.sh

RUN sed -i 's/\r$//' /usr/local/tomcat/entrypoint.sh && chmod +x /usr/local/tomcat/entrypoint.sh

EXPOSE 8080

CMD ["sh", "/usr/local/tomcat/entrypoint.sh"]

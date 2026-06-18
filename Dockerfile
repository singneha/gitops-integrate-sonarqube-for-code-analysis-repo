FROM tomcat:9.0.14-jre8-alpine

LABEL maintainer="https://github.com/singneha"

RUN rm -rf /usr/local/tomcat/webapps/ROOT

COPY webapp/ /usr/local/tomcat/webapps/

RUN ln -sf /bin/bash /bin/sh

EXPOSE 8080

CMD ["catalina.sh", "run"]
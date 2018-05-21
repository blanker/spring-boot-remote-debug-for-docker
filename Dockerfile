FROM openjdk:8-jdk
EXPOSE 15004 15005 15006
ENV TZ Asia/Shanghai
#COPY ./classes /usr/src/myapp
VOLUME ["/usr/src/myapp"]
WORKDIR /usr/src/myapp
CMD ["java", "HelloWorld"]


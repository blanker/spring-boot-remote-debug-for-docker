1 拉取openjdk8镜像
docker pull openjdk:8-jdk

2 拉取mysql5镜像
docker pull mysql:5

3 docker-compose.yml
===============================================================================
version: "3.6"
services:
        mysql-prod:
                image: mysql:5
                volumes:
                        - /home/slga/docker/prodheha/data:/var/lib/mysql
                        - /home/slga/docker/prodheha/conf:/etc/mysql/conf.d
                container_name: mysql-prod
                hostname: mysql-prod
                ports:
                        - "23306:3306"
                networks:
                        - mynet
                environment:
                        - MYSQL_ROOT_PASSWORD=my-secret-pw
                        - MYSQL_DATABASE=db
                        - MYSQL_USER=user
                        - MYSQL_PASSWORD=password-123321-Pass
                        - TZ=Asia/Shanghai
        spring-boot-app:
                image: my-java-app
        #        build: ./
                volumes:
                        - /home/slga/docker/prodheha/classes:/usr/src/myapp
                container_name: spring-boot-app
                hostname: spring-boot-app
                depends_on:
                        - mysql-prod
                command: ["java", "-agentpath:/usr/src/myapp/lib/libjrebel64.so", "-Drebel.remoting_plugin=true", "-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=15005", "-Dserver.port=15006", "-jar", "payment-app.jar"]
                ports:
                        - "15004:15004"
                        - "15005:15005"
                        - "15006:15006"
                networks:
                        - mynet
networks:
    mynet:
        external: true

===============================================================================		

4 mysql57配置文件 mysql.cnf
===============================================================================
[client]
default-character-set=utf8

[mysqld]
default-storage-engine=INNODB
character-set-server=utf8
collation-server=utf8_general_ci

lower-case-table-names=1

innodb_buffer_pool_size=256M
max_allowed_packet=100M
===============================================================================


5 8-jdk Dockerfile 

CMD
	Dockerfile中只能有一个CMD指令
	指定多个CMD指令，只有最后一个生效
	用于
		指定默认执行的命令 		CMD ["executable","param1","param2"]
		作为ENTRYPOINT的参数	CMD ["param1","param2"] 此时必须指定ENTRYPOINT
	必须用双引号不能用单引号

	docker run命令指定了参数会覆盖掉CMD命令

ENTRYPOINT ["executable", "param1", "param2"]
	
	docker run命令后面的参数会追加到ENTRYPOINT参数后面，同时覆盖掉CMD指定的
	docker run --entrypoint 来覆盖该指令的内容
	
===============================================================================
FROM openjdk:8-jdk
ENV TZ Asia/Shanghai
#COPY ./classes /usr/src/myapp
VOLUME ["/usr/src/myapp"]
WORKDIR /usr/src/myapp
EXPOSE 15004 15005 15006
CMD ["java", "HelloWorld"]
===============================================================================

docker build -t my-java-app .
docker run -it --rm -v /home/slga/docker/prodheha/classes:/usr/src/myapp  --name my-running-app my-java-app

docker-compose up -d
docker-compose stop

$ docker exec some-mysql sh -c 'exec mysqldump --all-databases -uroot -p"$MYSQL_ROOT_PASSWORD"' > /some/path/on/your/host/all-databases.sql



➜  prodheha sudo firewall-cmd --zone=public --permanent --add-port=15000-15010/tcp
success
➜  prodheha sudo firewall-cmd --reload
success


FROM confluentinc/cp-kafka:latest

COPY server.properties /etc/kafka/server.properties
COPY zookeeper.properties /etc/kafka/zookeeper.properties

EXPOSE 9092/tcp
EXPOSE 2181/tcp

CMD ["/etc/confluent/docker/run"]
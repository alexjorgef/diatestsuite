FROM influxdb:2.6

COPY influxdb.conf /etc/influxdb/influxdb.conf

EXPOSE 8086/tcp
EXPOSE 8088/tcp

CMD ["influxd", "--config", "/etc/influxdb/influxdb.conf"]
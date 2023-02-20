FROM postgres:15

COPY postgresql.conf /etc/postgresql/postgresql.conf

EXPOSE 5432/tcp

CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]
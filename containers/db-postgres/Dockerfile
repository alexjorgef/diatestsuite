FROM postgres:15

COPY postgresql.conf /etc/postgresql/postgresql.conf

EXPOSE 5432/tcp

ENV POSTGRES_USER=diadata_psql_user
ENV POSTGRES_PASSWORD=diadata_psql_pass
ENV POSTGRES_DB=diadata_psql_db

COPY pginit.sql /docker-entrypoint-initdb.d/

CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]
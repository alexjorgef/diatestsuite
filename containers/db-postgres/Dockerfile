FROM postgres:15

COPY postgresql.conf /etc/postgresql/postgresql.conf

EXPOSE 5432/tcp

ENV POSTGRES_USER=d2Vic2l0ZV91c2Vy
ENV POSTGRES_PASSWORD=cGFzcw==
ENV POSTGRES_DB=diadata_psql_db

COPY pginit.sql /docker-entrypoint-initdb.d/

CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]
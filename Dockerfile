FROM base/devel
MAINTAINER joe@joefiorini.com

RUN pacman -Syy && pacman -S --noconfirm reflector && reflector --verbose -l 200 -p http --sort rate --save /etc/pacman.d/mirrorlist

ADD postgresql-9.3.4.tar.gz /src
WORKDIR /src/postgresql-9.3.4

RUN ./configure && make && make install && make clean

WORKDIR /

RUN rm -rf /src/postgresql-9.3.4

ENV PATH $PATH:/usr/local/pgsql/bin

RUN mkdir /usr/local/pgsql/data && useradd -m postgres && chown postgres /usr/local/pgsql/data
RUN sudo -iu postgres /usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data

EXPOSE 5432

USER postgres

CMD postgres -D /usr/local/pgsql/data

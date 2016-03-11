FROM debian:jessie

RUN apt-get update

RUN apt-get install -y python-software-properties software-properties-common

RUN apt-add-repository 'deb http://packages.dotdeb.org jessie all'

RUN apt-get upgrade -y && apt-get -y install python-virtualenv python-pip postgresql postgresql-client libpq-dev postgresql-server-dev-all python-dev git

RUN git clone https://github.com/pirati-cz/helios-server /helios/

WORKDIR /helios/

RUN virtualenv venv

RUN bash -c 'source venv/bin/activate; pip install -r requirements.txt'

RUN echo 'local   all             all                                     trust' > /etc/postgresql/9.4/main/pg_hba.conf

ADD docker-entrypoint.sh /

ADD pirateid.png /helios/helios_auth/media/login-icons/

RUN echo > /.firstrun 

EXPOSE 8000

ENTRYPOINT /docker-entrypoint.sh


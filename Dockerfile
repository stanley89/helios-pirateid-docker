FROM debian:latest

EXPOSE 80

RUN apt-get update

RUN apt-get install -y python-software-properties software-properties-common

RUN apt-add-repository 'deb http://packages.dotdeb.org wheezy all'

RUN apt-get upgrade -y && apt-get -y install python-virtualenv python-pip postgresql postgresql-client unzip libpq-dev postgresql-server-dev-all python-dev

ADD https://github.com/benadida/helios-server/archive/master.zip /helios/

WORKDIR /helios/

RUN unzip master.zip

WORKDIR /helios/helios-server-master/

RUN virtualenv venv

RUN bash -c 'source venv/bin/activate; pip install -r requirements.txt'

RUN echo 'local   all             all                                     trust' > /etc/postgresql/9.4/main/pg_hba.conf

ADD docker-entrypoint.sh /

ADD pirateid.py /helios/helios-server-master/helios_auth/auth_systems/

ADD pirateid.png /helios/helios-server-master/helios_auth/media/login-icons/

RUN echo 'import pirateid' >> /helios/helios-server-master/helios_auth/auth_systems/__init__.py
RUN echo "AUTH_SYSTEMS['pirateid'] = pirateid" >> /helios/helios-server-master/helios_auth/auth_systems/__init__.py


RUN echo > /.firstrun 

EXPOSE 8000

ENTRYPOINT /docker-entrypoint.sh


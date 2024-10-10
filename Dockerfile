FROM ubuntu:18.04

RUN apt-get update && \
    apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq libpq-dev gcc python3.8 python3-pip && \
    apt-get clean

RUN python3 -m pip install --upgrade pip
RUN pip3 install psycopg2-binary Flask==1.1.2 Flask-Migrate==2.5.3 Flask-SQLAlchemy==2.4.4

WORKDIR /sample-app

COPY . /sample-app/

RUN pip3 install -r requirements.txt && \
    pip3 install -r requirements-server.txt

ENV FLASK_APP=app.py  # Adjust this if your main file has a different name
ENV DATABASE_URL=postgres://admin:a1a1a1@postgres:5432/DB

ENV LC_ALL="C.UTF-8"
ENV LANG="C.UTF-8"

EXPOSE 8000

CMD ["gunicorn", "app:app", "-b", "0.0.0.0:8000"]


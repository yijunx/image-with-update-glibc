FROM python:3.7.11-slim

ARG DOCKER_HOME="/opt/yijun"
ARG DOCKER_CODE="/opt/yijun/code"
ARG DOCKER_USER="yijun"
ARG DOCKER_UID=5000

RUN echo "deb http://ftp.debian.org/debian sid main" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y -t sid install libc6 libc6-dev libc6-dbg && \
    apt-get install -y gcc libpq-dev

RUN useradd -d ${DOCKER_HOME} -m -U -u ${DOCKER_UID} ${DOCKER_USER}

COPY requirements.txt requirements.txt

RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    rm requirements.txt

RUN apt-get purge -y gcc

USER ${DOCKER_USER}

WORKDIR ${DOCKER_CODE}

ENV PYTHONPATH=.

COPY --chown=${DOCKER_USER} . .

CMD ["gunicorn", "app.app:app", "-w", "3", "-b", "0.0.0.0:8000"] 
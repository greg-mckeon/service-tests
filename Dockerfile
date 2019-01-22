FROM debian:9.6
COPY test_suites_405 /test_suites_405
COPY dev-requirements.txt /dev-requirements.txt
COPY components /components
RUN apt-get update && \
    apt-get install -y git python2.7 python-pip gcc libcurl4-openssl-dev libssl-dev wget && \
    git clone --depth 1 --branch r4.0.5 https://github.com/mongodb/mongo && \
    pip install --user -r /dev-requirements.txt && \
    cp /test_suites_405/* /mongo/buildscripts/resmokeconfig/suites && \
    wget https://downloads.mongodb.org/linux/mongodb-shell-linux-x86_64-debian92-4.0.5.tgz && \
    tar xzf mongodb-shell-linux-x86_64-debian92-4.0.5.tgz && \
    rm -rf /var/lib/apt/lists/* /tmp/* /mongodb-shell-linux-x86_64-debian92-4.0.5.tgz
COPY entrypoint.sh /entrypoint.sh
ENV mongo='/mongodb-linux-x86_64-debian92-4.0.5/bin/mongo'
ADD https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem /usr/local/share/ca-certificates/rds-combined-ca-bundle.crt
RUN update-ca-certificates
ENTRYPOINT ["/entrypoint.sh"]

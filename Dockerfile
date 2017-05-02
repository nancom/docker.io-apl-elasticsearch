FROM nancom/apl-jdk8
MAINTAINER Nancom, https://github.com/nancom/docker-alpine

# Set environment variables
ENV PKG_NAME elasticsearch
ENV ELASTICSEARCH_VERSION 5.3.2

RUN mkdir -p /opt/elk
RUN adduser -D -h /opt/elk elk

# Set the working directory to jboss' user home directory
WORKDIR /opt/elk

COPY elasticsearch-5.3.2.tar.gz /tmp
# Download Elasticsearch
RUN apk update \
    && apk add tzdata openssl \
    && tar -xvzf /tmp/$PKG_NAME-$ELASTICSEARCH_VERSION.tar.gz -C /opt/elk \
    && ln -s /opt/elk/$PKG_NAME-$ELASTICSEARCH_VERSION /opt/elk/$PKG_NAME \
    && rm -rf /tmp/*.tar.gz /var/cache/apk/* \
    && mkdir /var/lib/elasticsearch \
    && chown elk /var/lib/elasticsearch

# Add files
COPY config/elasticsearch.yml /opt/elk/elasticsearch/config/elasticsearch.yml
COPY scripts/run.sh /scripts/run.sh

# Specify Volume
VOLUME ["/var/lib/elasticsearch"]

# Exposes
EXPOSE 9200
EXPOSE 9300
RUN chown -R elk /opt/elk
RUN chown -R elk /var/lib/elasticsearch
RUN chown -R elk /var/lib/

USER elk

# CMD
ENTRYPOINT ["/scripts/run.sh"]

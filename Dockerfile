FROM sgrio/java:jdk_8_alpine

ENV RELEASE_VERSION 2.1.214
ENV RELEASE_DATE 2022-06-13
ENV H2DATA /h2-data

RUN apk update && apk add bash

RUN curl https://github.com/h2database/h2database/releases/download/version-$RELEASE_VERSION/h2-$RELEASE_DATE.zip -L -o h2.zip \
    && unzip h2.zip -d . \
    && rm h2.zip

RUN ln -s $(ls /h2/bin/*jar) /h2/bin/h2.jar

RUN mkdir /docker-entrypoint-initdb.d

VOLUME /h2-data

EXPOSE 8082 9092

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD java -cp /h2/bin/h2.jar org.h2.tools.Server \
  -web -webAllowOthers -tcp -tcpAllowOthers -baseDir $H2DATA

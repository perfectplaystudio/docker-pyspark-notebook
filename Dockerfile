FROM dpatriot/docker-spark

MAINTAINER Shago Vyacheslav <v.shago@corpwebgames.com>

ENV PYTHONPATH $SPARK_HOME/python/:$PYTHONPATH
ENV CLASSPATH /usr/local/spark/lib/mysql-connector-java.jar

RUN apt-get update \
    && apt-get install -y build-essential \
    python \
    python-dev \
    python-pip \
    python-zmq \
    && rm -rf /var/lib/apt/lists/*

RUN pip install py4j \
    ipython[notebook]==3.2 \
    jsonschema \
    jinja2 \
    terminado \
    tornado

RUN ipython profile create pyspark

COPY pyspark-notebook.py /root/.ipython/profile_pyspark/startup/pyspark-notebook.py

VOLUME /notebook
WORKDIR /notebook

EXPOSE 8888
ENTRYPOINT []

CMD aws s3 cp s3://$S3_BUCKET_CONF/hive/config/core-site.xml /usr/local/spark/conf/core-site.xml;aws s3 cp s3://$S3_BUCKET_CONF/hive/config/hive-site.xml /usr/local/spark/conf/hive-site.xml;ipython notebook --no-browser --profile=pyspark --ip=*

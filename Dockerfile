FROM dpatriot/docker-spark

MAINTAINER Shago Vyacheslav <v.shago@corpwebgames.com>

ENV PYTHONPATH $SPARK_HOME/python/:$PYTHONPATH

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

ENTRYPOINT ["docker-run-spark-env.sh"]
CMD ipython notebook --no-browser --profile=pyspark --ip=*

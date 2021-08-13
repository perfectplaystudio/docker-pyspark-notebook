FROM jupyter/pyspark-notebook:python-3.9.6

MAINTAINER Eugeny Birukov <e.birukov@perfertplaystudio.com>

ENV PYTHONPATH $SPARK_HOME/python/:$PYTHONPATH

RUN pip install setuptools wheel requests awscli asana pandas sqlalchemy datetime

COPY jupyter_notebook_config.json /home/jovyan/.jupyter/jupyter_notebook_config.json

EXPOSE 8888
ENTRYPOINT []

USER root

RUN chown jovyan /usr/local/spark/conf/ && chown -R jovyan /opt/conda/share/jupyter/



VOLUME /notebook
WORKDIR /notebook

ENV SPARK_CLASSPATH /usr/local/spark/jars/mysql-connector-java.jar:/usr/local/spark/jars/spark-avro.jar:/usr/local/spark/jars/spark-redshift.jar:/usr/local/spark/jars/RedshiftJDBC41-1.1.10.1010.jar:/usr/local/spark/jars/minimal-json.jar

CMD aws s3 cp s3://$S3_BUCKET_CONF/hive/config/core-site.xml /usr/local/spark/conf/core-site.xml;aws s3 cp s3://$S3_BUCKET_CONF/hive/config/hive-site.xml /usr/local/spark/conf/hive-site.xml;jupyter notebook --no-browser --allow-root --ip=*

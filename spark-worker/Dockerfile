FROM openjdk:8-jre-slim

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV SPARK_VERSION=3.2.1
ENV HADOOP_VERSION=3.2
ENV SPARK_HOME=/opt/spark-${SPARK_VERSION}
ENV PATH=$PATH:${SPARK_HOME}/bin
ENV SPARK_MASTER_HOST=spark-master
ENV SPARK_MASTER_PORT=7077

# Download and install Spark
RUN wget https://downloads.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    tar -xvzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} ${SPARK_HOME} && \
    rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz

# Set up Spark configuration
COPY spark-env.sh ${SPARK_HOME}/conf/
COPY workers ${SPARK_HOME}/conf/
COPY spark-defaults.conf ${SPARK_HOME}/conf/

# Expose ports
EXPOSE 4040 6066 7077 8080 8081

# Start Spark worker
CMD ["./bin/spark-class", "org.apache.spark.deploy.worker.Worker", "spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT}"]

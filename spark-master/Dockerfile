###################################################
# SPARK & DELTA
###################################################

FROM openjdk:8-jre-slim

# Set environment variables
ENV SPARK_VERSION=3.2.1
ENV HADOOP_VERSION=3.2.0
ENV SPARK_HOME=/opt/spark
ENV PATH=$PATH:${SPARK_HOME}/bin:${SPARK_HOME}/sbin

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*

# Download and install Spark
RUN wget https://downloads.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    tar -xvzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} ${SPARK_HOME} && \
    rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
    pip install pyspark \
    pip install -i https://test.pypi.org/simple/ delta-spark==2.3.0rc1

# Copy configuration files
COPY spark-defaults.conf ${SPARK_HOME}/conf/

# Expose ports
EXPOSE 4040 6066 7077 8080 8081

###################################################
# HIVE
###################################################

# Set environment variables
ENV HIVE_HOME=/opt/hive
ENV PATH=$PATH:${HIVE_HOME}/bin

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*

# Download and install Hive
RUN wget https://downloads.apache.org/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz && \
    tar -xvzf apache-hive-${HIVE_VERSION}-bin.tar.gz && \
    mv apache-hive-${HIVE_VERSION}-bin ${HIVE_HOME} && \
    rm apache-hive-${HIVE_VERSION}-bin.tar.gz

# Set up Hive configuration
COPY hive-site.xml ${HIVE_HOME}/conf/

# Expose port
EXPOSE 10000



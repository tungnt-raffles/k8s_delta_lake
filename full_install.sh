###################################################################
###################################################################
###################################################################
######## spark

#!/bin/bash

# Update the package index and install the OpenJDK Java runtime environment
sudo apt-get update
sudo apt-get install default-jre

# Download and extract the Spark archive from the official website
wget https://downloads.apache.org/spark/spark-3.2.0/spark-3.2.0-bin-hadoop3.2.tgz
tar -xzf spark-3.2.0-bin-hadoop3.2.tgz
sudo mv spark-3.2.0-bin-hadoop3.2 /usr/local/spark

# Set the SPARK_HOME environment variable
echo "export SPARK_HOME=/usr/local/spark" >> ~/.bashrc
echo "export PATH=\$PATH:\$SPARK_HOME/bin" >> ~/.bashrc

# Reload the bashrc file
source ~/.bashrc

# Print the Spark version to verify the installation
spark-submit --version

###################################################################
###################################################################
###################################################################
########### delta

#!/bin/bash

# Update the package index and install the OpenJDK Java runtime environment
sudo apt-get update
sudo apt-get install default-jre

# Download and extract the Delta Lake archive from the official website
wget https://repo1.maven.org/maven2/io/delta/delta-core_2.12/1.0.0/delta-core_2.12-1.0.0.jar
sudo mv delta-core_2.12-1.0.0.jar /usr/local/delta

pip install pyspark
pip install delta-spark

###################################################################
###################################################################
###################################################################
######## minio

#!/bin/bash

# Download and install MinIO server
wget https://dl.min.io/server/minio/release/linux-amd64/minio
chmod +x minio
sudo mv minio /usr/local/bin/

# Create a new user and group for MinIO
sudo groupadd minio
sudo useradd -g minio minio

# Create a data directory for MinIO
sudo mkdir -p /var/lib/minio/data
sudo chown -R minio:minio /var/lib/minio

# Create a configuration file for MinIO
sudo mkdir -p /etc/minio
sudo tee /etc/minio/config.json > /dev/null <<EOF
{
    "version": "1",
    "credential": {
        "accessKey": "YOUR_ACCESS_KEY",
        "secretKey": "YOUR_SECRET_KEY"
    },
    "region": "us-east-1",
    "browser": "on",
    "storage": {
        "type": "filesystem",
        "filesystem": {
            "rootDirectory": "/var/lib/minio/data"
        }
    }
}
EOF

# Replace YOUR_ACCESS_KEY and YOUR_SECRET_KEY with your own values

# Create a systemd service file for MinIO
sudo tee /etc/systemd/system/minio.service > /dev/null <<EOF
[Unit]
Description=MinIO
After=network.target

[Service]
User=minio
Group=minio
ExecStart=/usr/local/bin/minio server /var/lib/minio
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload the systemd configuration
sudo systemctl daemon-reload

# Start the MinIO service
sudo systemctl start minio

# Enable the MinIO service to start at boot time
sudo systemctl enable minio

# Print the MinIO version to verify the installation
minio version

###################################################################
###################################################################
###################################################################
######## presto

#!/bin/bash

# Add the Presto repository
wget https://repo1.maven.org/maven2/io/prestosql/presto-server/0.258/presto-server-0.258.tar.gz
tar -zxvf presto-server-0.258.tar.gz -C /usr/local/
ln -s /usr/local/presto-server-0.258 /usr/local/presto

# Create the Presto user and group
groupadd presto
useradd -g presto presto

# Set up the Presto configuration
mkdir -p /etc/presto/catalog
cp /usr/local/presto-server-0.258/etc/node.properties /etc/presto/
cp /usr/local/presto-server-0.258/etc/jvm.config /etc/presto/
cp /usr/local/presto-server-0.258/etc/config.properties /etc/presto/
cp /usr/local/presto-server-0.258/etc/log.properties /etc/presto/
chown -R presto:presto /etc/presto

# Start the Presto server
sudo -u presto /usr/local/presto-server-0.258/bin/launcher start

echo "Presto is now installed and running"



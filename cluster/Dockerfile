FROM izone/hadoop:cluster
ADD cluster.sh /etc/cluster.sh
RUN apt-get install -y iputils-ping vim
RUN curl https://cdn.mysql.com/archives/mysql-connector-java-5.1/mysql-connector-java-5.1.49.tar.gz -o /tmp/mysql.tgz && tar -zxf /tmp/mysql.tgz -C /tmp/ && mv /tmp/mysql-connector-java-5.1.49/mysql-connector-java-5.1.49-bin.jar /opt/hive/lib/ && rm -rf /tmp/mysql*
ADD hive-site.xml /opt/hive/conf/
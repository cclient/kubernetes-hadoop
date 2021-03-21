# k8s hadoop simple cluster

use image [izone/hadoop](https://hub.docker.com/r/izone/hadoop/)

cluster/cluster.sh [origin](https://github.com/luvres/hadoop/blob/master/cluster/cluster.sh)

datanode/start.sh [origin](https://github.com/luvres/hadoop/blob/master/cluster/datanode/start.sh)

## images

### datanode

cd ../datanode

docker build -t cclient/hadoop:2.8.3-datanode ./

docker build --build-arg http_proxy= --build-arg https_proxy= -t cclient/hadoop:2.8.3-datanode ./

### namenode

cd ../cluster

docker build -t cclient/hadoop:2.8.3-namenode ./

docker build --build-arg http_proxy= --build-arg https_proxy= -t cclient/hadoop:2.8.3-namenode ./

## deploy

datanode must have started before deploy namenode(namenode ssh datanode to config)

### datanode

kubectl apply -f deploy-datanode.yml

### namenode

kubectl apply -f deploy-namenode.yml

### start hive 

```
kubectl exec -it hadoop-master-0 bash
# init 
cd /opt/hive/bin
/opt/hive/bin/hive --service schemaTool  -initSchema -dbType mysql
# start
nohup /opt/hive/bin/hive --service hiveserver2 &
# connect

/opt/hive/bin/beeline -u jdbc:hive2://127.0.0.1:10000  -nroot -phadoop

0: jdbc:hive2://127.0.0.1:10000> show databases;
+----------------+
| database_name  |
+----------------+
| default        |
+----------------+
1 row selected (1.929 seconds)

```

## show

```bash
$ kubectl get pods
NAME              READY   STATUS    RESTARTS   AGE
hadoop-master-0   1/1     Running   0          10h
hadoop-node-0     1/1     Running   0          10h

$ kubectl get svc
NAME            TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                                                                                                                                                                  AGE
hadoop-master                NodePort       10.96.64.27      <none>        22:32620/TCP,8088:32688/TCP,8042:31507/TCP,50030:32630/TCP,50070:32670/TCP,8888:32488/TCP,4040:31798/TCP,8787:30829/TCP,9000:30760/TCP,60010:32510/TCP,60030:32530/TCP,10000:32000/TCP,10002:32002/TCP   11m
hadoop-node                  ClusterIP      10.100.139.149   <none>        22/TCP                                                             11m
```

## view demo

### hadoop

cluster http://k8s-node-ip:32688

![cluster.png](./image/cluster.png)

namenode  http://k8s-node-ip:32670

![namenode.png](./image/namenode.png)

### hbase

hbase-master http://k8s-node-ip:32510

![hbase.png](./image/hbase.png)

hbase-regionserver http://k8s-node-ip:32530

![hbase-region.png](./image/hbase-region.png)

### hive

hive http://k8s-node-ip:32002

![hive.png](./image/hive.png)

### jupyter

notebook http://k8s-node-ip:32488

kafka



---

  <property>
    <name>hive.server2.support.dynamic.service.discovery</name>
    <value>false</value>
    <description>Whether HiveServer2 supports dynamic service discovery for its clients. To support this, each instance of HiveServer2 currently uses ZooKeeper to register itself, when it is brought up. JDBC/ODBC clients should use the ZooKeeper ensemble: hive.zookeeper.quorum in their connection string.</description>
  </property>

  
```

<property>
  <name>yarn.nodemanager.vmem-check-enabled</name>
  <value>false</value>
  <description>Whether virtual memory limits will be enforced for containers</description>
</property>
<property>
  <name>yarn.nodemanager.vmem-pmem-ratio</name>
  <value>4</value>
  <description>Ratio between virtual memory to physical memory when setting memory limits for containers</description>
</property>


[root@hadoop-aio-0:/opt/hive/bin]# stop-yarn.sh 
stopping yarn daemons
stopping resourcemanager
1: ssh: connect to host 1 port 22: Invalid argument
hadoop-aio-0: stopping nodemanager


/opt/spark/bin/spark-submit --deploy-mode client  --master yarn --executor-memory 512m --driver-memory 512m --num-executors 1 --executor-cores 1 --class com.tencent.tbds.demo.spark.SparkDemo ~/dev-demo-5.1.3.0.jar /tbds/README.md /tbds_SparkDemo/   


[root@hadoop-aio-0:/opt/hive/bin]# hdfs dfs -text /tbds_SparkDemo/part-00000
(package,1)
(For,3)
(Programs,1)
(processing.,1)
(Because,1)
(The,1)
(page](http://spark.apache.org/documentation.html).,1)
(cluster.,1)
(its,1)

...



./bin/spark_write_hive_table_demo.sh --hive-metastore-uris <hive metastore address> --hive-db <hive database> --hive-table <hive table name> --hdfs-path <hdfs path>


./bin/spark_read_hive_table_demo.sh --auth-user stevexi --auth-id kGIIdqdImbBw2YOjttCVSh3psx7tQ0OMSPHb --auth-key 2wZEaVcj1uniYJk6Enhj2jNI288YzEgW --hive-metastore-uris thrift://tbds-172-27-0-223:9083,thrift://tbds-172-27-0-25:9083 --hive-db wfdemodb --hive-table expense_cal



create database wfdemodb;

create table wfdemodb.occupation (p_id int, occupation string);
create table wfdemodb.name (p_id int, name string);
create table wfdemodb.expense (t_date string, p_id int, expense decimal(13,2));
create table wfdemodb.expense_cal (t_date string, p_id int, name string, occupation string, expense decimal(13,2));


~/bin/spark_read_hive_table_demo.sh --hive-metastore-uris thrift://127.0.0.1:10000 --hive-db wfdemodb --hive-table expense_cal


/opt/spark/bin/spark-submit --class com.tencent.tbds.demo.spark.SparkReadHiveTableDemo ~/dev-demo-5.1.3.0.jar--master yarn --deploy-mode client  --hive-metastore-uris thrift://127.0.0.1:10000 --hive-db wfdemodb --hive-table expense_cal


读hive 
/opt/spark/bin/spark-submit --deploy-mode client  --master yarn --executor-memory 512m --driver-memory 512m --num-executors 1 --executor-cores 1 --class com.tencent.tbds.demo.spark.SparkReadHiveTableDemo ~/dev-demo-5.1.3.0.jar --hive-metastore-uris thrift://127.0.0.1:9083 --hive-db wfdemodb --hive-table tb_class_info


/opt/spark/bin/spark-submit --deploy-mode client  --master yarn --executor-memory 512m --driver-memory 512m --num-executors 1 --executor-cores 1 --class com.tencent.tbds.demo.spark.SparkReadHiveTableDemo ~/dev-demo-5.1.3.0.jar --hive-metastore-uris jdbc:hive2://127.0.0.1:10000 --hive-db wfdemodb --hive-table expense_cal


nohup ./hive --service metastore  >> metastore.log &


/opt/spark/bin/spark-submit --deploy-mode client  --master yarn --executor-memory 512m --driver-memory 512m --num-executors 1 --executor-cores 1 --class com.tencent.tbds.demo.spark.SparkReadHiveTableDemo ~/dev-demo-5.1.3.0.jar --hive-metastore-uris thrift://127.0.0.1:9083 --hive-db wfdemodb --hive-table expense_cal


21/03/19 04:04:12 INFO memory.MemoryStore: Block broadcast_0 stored as values in memory (estimated size 287.9 KB, free 93.0 MB)
21/03/19 04:04:12 INFO memory.MemoryStore: Block broadcast_0_piece0 stored as bytes in memory (estimated size 24.4 KB, free 93.0 MB)
21/03/19 04:04:12 INFO storage.BlockManagerInfo: Added broadcast_0_piece0 in memory on 10.18.77.34:45273 (size: 24.4 KB, free: 93.3 MB)
21/03/19 04:04:12 INFO spark.SparkContext: Created broadcast 0 from 
21/03/19 04:04:13 INFO mapred.FileInputFormat: Total input paths to process : 0
+------+----+----+----------+-------+
|t_date|p_id|name|occupation|expense|
+------+----+----+----------+-------+
+------+----+----+----------+-------+



hdfs dfs -mkdir -p /wfDemo/hdfsData 2>/dev/null
hdfs dfs -mkdir -p /wfDemo/ftp2HdfsData 2>/dev/null
cat /dev/null > /tmp/occupation.csv
echo "1,Engineer" >> /tmp/occupation.csv
echo "2,Doctor" >> /tmp/occupation.csv         
echo "3,Teacher" >> /tmp/occupation.csv           
cat /tmp/occupation.csv 
hdfs dfs -put -f /tmp/occupation.csv  /wfDemo/hdfsData 2>/dev/null
hdfs dfs -chmod -R 777 /wfDemo 2>/dev/null
hdfs dfs -ls /wfDemo 2>/dev/null
hdfs dfs -cat /wfDemo/hdfsData/occupation.csv 2>/dev/null


写HIVE
/opt/spark/bin/spark-submit --class com.tencent.tbds.demo.spark.SparkWriteHiveTableDemo --master yarn --deploy-mode client ~/dev-demo-5.1.3.0.jar --hive-metastore-uris thrift://127.0.0.1:9083 --hive-db wfdemodb --hive-table tb_class_info  --hdfs-path /tbds/tb_class.txt


读HIVE 
hdfs 写入


1.查看hdfs系统上的文件

cat /dev/null > /tmp/tb_class.txt
echo "0|班级0|2014-10-29 14:10:17|2014-10-29 14:10:17" >> /tmp/tb_class.txt
echo "1|班级1|2014-10-29 14:10:17|2014-10-29 14:10:17" >> /tmp/tb_class.txt
echo "2|班级2|2014-10-29 14:10:17|2014-10-29 14:10:17" >> /tmp/tb_class.txt

hdfs dfs -mkdir /tbds
hdfs dfs -copyFromLocal /tmp/tb_class.txt   /tbds/


hadoop fs -cat /tbds/tb_class.txt





2.创建表

create table tb_class_info
(id int,class_name string,createtime timestamp,modifytime timestamp) ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' STORED AS TEXTFILE;

 
/opt/hive/bin/beeline -u jdbc:hive2://127.0.0.1:10000  -nroot -phadoop

0: jdbc:hive2://127.0.0.1:10000> show databases;
+----------------+
| database_name  |
+----------------+
| default        |
| wfdemodb       |
+----------------+

0: jdbc:hive2://127.0.0.1:10000> use wfdemodb;
No rows affected (0.087 seconds)
0: jdbc:hive2://127.0.0.1:10000> create table tb_class_info
. . . . . . . . . . . . . . . .> (id int,class_name string,createtime timestamp,modifytime timestamp) ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' STORED AS TEXTFILE;
No rows affected (0.195 seconds)
0: jdbc:hive2://127.0.0.1:10000> show tables;
+----------------+
|    tab_name    |
+----------------+
| expense        |
| expense_cal    |
| name           |
| occupation     |
| tb_class_info  |
+----------------+
5 rows selected (0.143 seconds)
0: jdbc:hive2://127.0.0.1:10000> 

3.导入表

load data inpath '/user/hadoop1/myfile/tb_class.txt' into table tb_class_info;

0: jdbc:hive2://127.0.0.1:10000> load data inpath '/tbds/tb_class.txt' into table tb_class_info;
No rows affected (0.816 seconds)
0: jdbc:hive2://127.0.0.1:10000> show tables;
+----------------+
|    tab_name    |
+----------------+
| expense        |
| expense_cal    |
| name           |
| occupation     |
| tb_class_info  |
+----------------+
5 rows selected (0.13 seconds)
0: jdbc:hive2://127.0.0.1:10000> select * from tb_class_info;
+-------------------+---------------------------+---------------------------+---------------------------+
| tb_class_info.id  | tb_class_info.class_name  | tb_class_info.createtime  | tb_class_info.modifytime  |
+-------------------+---------------------------+---------------------------+---------------------------+
| 0                 | 0                         | 2014-10-29 14:10:17.0     | 2014-10-29 14:10:17.0     |
| 1                 | 1                         | 2014-10-29 14:10:17.0     | 2014-10-29 14:10:17.0     |
| 2                 | 2                         | 2014-10-29 14:10:17.0     | 2014-10-29 14:10:17.0     |
+-------------------+---------------------------+---------------------------+---------------------------+
3 rows selected (1.185 seconds)
0: jdbc:hive2://127.0.0.1:10000> 


0: jdbc:hive2://127.0.0.1:10000> select * from tb_class_info;
+-------------------+---------------------------+---------------------------+---------------------------+
| tb_class_info.id  | tb_class_info.class_name  | tb_class_info.createtime  | tb_class_info.modifytime  |
+-------------------+---------------------------+---------------------------+---------------------------+
| 0                 | 0                         | 2014-10-29 14:10:17.0     | 2014-10-29 14:10:17.0     |
| 1                 | 1                         | 2014-10-29 14:10:17.0     | 2014-10-29 14:10:17.0     |
| 2                 | 2                         | 2014-10-29 14:10:17.0     | 2014-10-29 14:10:17.0     |
+-------------------+---------------------------+---------------------------+---------------------------+
3 rows selected (1.185 seconds)
0: jdbc:hive2://127.0.0.1:10000> true Display all 560 possibilities? (y or n)
0: jdbc:hive2://127.0.0.1:10000> truncate table tb_class_info;
No rows affected (0.243 seconds)
0: jdbc:hive2://127.0.0.1:10000> select * from tb_class_info;
+-------------------+---------------------------+---------------------------+---------------------------+
| tb_class_info.id  | tb_class_info.class_name  | tb_class_info.createtime  | tb_class_info.modifytime  |
+-------------------+---------------------------+---------------------------+---------------------------+
+-------------------+---------------------------+---------------------------+---------------------------+
No rows selected (0.164 seconds)
0: jdbc:hive2://127.0.0.1:10000> 


Exception in thread "main" java.io.IOException: Malformed ORC file hdfs://hadoop-aio-0:9000/tbds/tb_class.txt. Invalid postscript.

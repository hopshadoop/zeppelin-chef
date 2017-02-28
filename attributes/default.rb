include_attribute "kagent"
include_attribute "hops"
include_attribute "hadoop_spark"
include_attribute "flink"

default.zeppelin.version             = "0.7.1-SNAPSHOT"
default.zeppelin.spark_version       = node.hadoop_spark.version
default.zeppelin.hadoop_version      = "2.7"
default.zeppelin.name                = "zeppelin-#{node.zeppelin.version}-bin-spark-#{node.zeppelin.spark_version}_hadoop-#{node.zeppelin.hadoop_version}"
default.zeppelin.user                = node.hops.yarn.user
default.zeppelin.group               = node.hops.group
default.zeppelin.port                = 58206
default.zeppelin.dir                 = "/srv"
default.zeppelin.base_dir            = node.zeppelin.dir + "/zeppelin" 
default.zeppelin.home                = node.zeppelin.dir + "/zeppelin-" + node.zeppelin.version

default.zeppelin.url                 = "#{node.download_url}/#{node.zeppelin.name}.tar.gz"

default.zeppelin.executor_memory     = "512m"
default.zeppelin.driver_memory       = "1g"
default.zeppelin.eventlog_enabled    = "true"


include_attribute "kagent"
include_attribute "hops"
include_attribute "hadoop_spark"
include_attribute "flink"
include_attribute "hive2"

default['zeppelin']['version']             = "0.8.0-SNAPSHOT"
default['zeppelin']['spark_version']       = node['hadoop_spark']['version']
default['zeppelin']['hadoop_version']      = "2.7"
default['zeppelin']['name']                = "zeppelin-#{node['zeppelin']['version']}-bin-spark-#{node['zeppelin']['spark_version']}_hadoop-#{node['zeppelin']['hadoop_version']}"
default['zeppelin']['user']                = node['hops']['yarn']['user']
default['zeppelin']['group']               = node['hops']['group']
default['zeppelin']['port']                = 58206

default['zeppelin']['dir']                 = node['install']['dir'].empty? ? "/srv" : node['install']['dir']
default['zeppelin']['base_dir']            = node['zeppelin']['dir'] + "/zeppelin"
default['zeppelin']['home']                = node['zeppelin']['dir'] + "/zeppelin-" + node['zeppelin']['version']

default['zeppelin']['url']                 = "#{node['download_url']}/#{node['zeppelin']['name']}.tar.gz"
# sha-256 checksum
default['zeppelin']['checksum']            = "3b36f626efa88d9bc2d2904330a1c4a8dbc7226643ffba21984efc5f8c5adf6a"

default['zeppelin']['hopshive_interpreter']            = "#{node['download_url']}/zeppelin-hopshive-#{node['zeppelin']['version']}.tar.gz"
default['zeppelin']['hopshive_jdbc']        = "#{node['download_url']}/hive-jdbc-#{node['hive2']['version']}-standalone.jar"

default['zeppelin']['executor_memory']     = "512m"
default['zeppelin']['driver_memory']       = "1g"
default['zeppelin']['eventlog_enabled']    = "true"


name             "zeppelin"
maintainer       "Jim Dowling"
maintainer_email "jdowling@kth.se"
license          "Apache v2"
description      'Installs/Configures Zeppelin'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.7.0"
source_url       "https://github.com/hopshadoop/zeppelin-chef"



depends          "flink"
depends          "hive2"
depends          "hadoop_spark"
depends          "ndb"
depends          "hops"
depends          "kagent"
depends          "java"

recipe           "install", "Installs Zeppelin binaries"
recipe           "default", "Starts a Zeppelin master"
recipe           "purge", "Removes and deletes Zeppelin"


attribute "zeppelin/user",
          :description => "User to install/run zeppelin as",
          :type => 'string'

attribute "zeppelin/group",
          :description => "Group to install/run zeppelin as",
          :type => 'string'

attribute "zeppelin/dir",
          :description => "zeppelin base dir",
          :type => 'string'

attribute "zeppelin/default/private_ips",
          :description => "Set ip addresses",
          :type => "array"

attribute "install/dir",
          :description => "Set to a base directory under which we will install.",
          :type => "string"

attribute "install/user",
          :description => "User to install the services as",
          :type => "string"

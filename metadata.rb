name             "zeppelin"
maintainer       "Jim Dowling"
maintainer_email "jdowling@kth.se"
license          "Apache v2"
description      'Installs/Configures Zeppelin'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.2"
source_url       "https://github.com/hopshadoop/zeppelin-chef"



depends          "flink"
depends          "hadoop_spark"
depends          "ndb"
depends          "hops"
depends          "kagent"
depends          "java"

recipe           "install", "Installs Zeppelin binaries"
recipe           "default", "Starts a Zeppelin master"
recipe           "purge", "Removes and deletes Zeppelin"


attribute "java/jdk_version",
          :description =>  "Jdk version",
          :type => 'string'

attribute "java/install_flavor",
          :description =>  "Oracle (default) or openjdk",
          :type => 'string'

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

#
# Cookbook Name:: zeppelin
# Recipe:: install
#
# Copyright 2015, Jim Dowling
#
# All rights reserved
#

include_recipe "java"

group node['zeppelin']['group'] do
  action :create
  not_if "getent group #{node['zeppelin']['group']}"
end

user node['zeppelin']['user'] do
  action :create
  gid node['zeppelin']['group']
  system true
  home "/home/#{node['zeppelin']['user']}"
  shell "/bin/bash"
  manage_home true
  not_if "getent passwd #{node['zeppelin']['user']}"
end

group node['zeppelin']['group'] do
  action :modify
   members ["#{node['zeppelin']['user']}"]
  append true
end

directory node['zeppelin']['dir'] do
  owner node['zeppelin']['user']
  group node['hops']['group']
  mode "0750"
  action :create
  not_if { File.directory?("#{node['zeppelin']['dir']}") }
end


# Zeppelin
package_url = "#{node['zeppelin']['url']}"
base_package_filename = File.basename(package_url)
cached_zeppelin_filename = "#{Chef::Config['file_cache_path']}/#{base_package_filename}"

remote_file cached_zeppelin_filename do
  source package_url
  owner "#{node['zeppelin']['user']}"
  checksum node['zeppelin']['checksum']
  mode "0644"
  action :create_if_missing
end

# Zeppelin HopsHive interpreter
package_url = "#{node['zeppelin']['hopshive_interpreter']}"
base_package_filename = File.basename(package_url)
cached_hopshive_int_filename = "#{Chef::Config[:file_cache_path]}/#{base_package_filename}"

remote_file cached_hopshive_int_filename do
  source package_url
  owner "#{node['zeppelin']['user']}"
  mode "0644"
  action :create_if_missing
end

# HopsHive JDBC connector
package_url = "#{node['zeppelin']['hopshive_jdbc']}"
base_package_filename = File.basename(package_url)
cached_hopshive_jdbc_filename = "#{Chef::Config[:file_cache_path]}/#{base_package_filename}"

remote_file cached_hopshive_jdbc_filename do
  source package_url
  owner node['zeppelin']['user']
  mode "0644"
  action :create_if_missing
end

zeppelin_down="#{node['zeppelin']['home']}/.zeppelin_extracted_#{node['zeppelin']['version']}"
# Extract Zeppelin
bash 'extract-zeppelin' do
        user "root"
        group node['zeppelin']['group']
        code <<-EOH
                set -e
                cd #{Chef::Config['file_cache_path']}
                tar -xf #{cached_zeppelin_filename} -C #{Chef::Config['file_cache_path']}
                mv #{Chef::Config['file_cache_path']}/zeppelin-#{node['zeppelin']['version']} #{node['zeppelin']['dir']}
                mkdir -p #{node['zeppelin']['home']}/run
                tar -xf #{cached_hopshive_int_filename} -C #{node['zeppelin']['home']}/interpreter
                cp #{cached_hopshive_jdbc_filename} #{node['zeppelin']['home']}/interpreter/hopshive/
                chown -R #{node['zeppelin']['user']}:#{node['hops']['group']} #{node['zeppelin']['home']}
                chmod 770 #{node['zeppelin']['home']}
                touch #{zeppelin_down}
        EOH
     not_if { ::File.exists?( "#{zeppelin_down}" ) }
end


link node['zeppelin']['base_dir'] do
  owner node['zeppelin']['user']
  group node['zeppelin']['group']
  to node['zeppelin']['home']
end


my_ip = my_private_ip()

file "#{node['zeppelin']['home']}/conf/zeppelin-env.sh" do
 action :delete
end

template "#{node['zeppelin']['home']}/conf/zeppelin-env.sh" do
  source "zeppelin-env.sh.erb"
  owner node['zeppelin']['user']
  group node['zeppelin']['group']
  mode 0655
  variables({
        :private_ip => my_ip,
        :hadoop_dir => node['hops']['base_dir'],
        :spark_dir => node['hadoop_spark']['base_dir']
           })
end

file "#{node['zeppelin']['home']}/conf/interpreter.json" do
 action :delete
end

template "#{node['zeppelin']['home']}/conf/interpreter.json" do
  source "interpreter.json.erb"
  owner node['zeppelin']['user']
  group node['zeppelin']['group']
  mode 0655
  variables({
        :hadoop_home => node['hops']['base_dir'],
        :spark_home => node['hadoop_spark']['base_dir'],
        :zeppelin_home => node['zeppelin']['base_dir'],
        :version => node['zeppelin']['version']
  })
end

template "#{node['zeppelin']['home']}/bin/alive.sh" do
  source "alive.sh.erb"
  owner node['zeppelin']['user']
  group node['zeppelin']['group']
  mode 0755
  variables({
           })
end

directory "#{node['zeppelin']['home']}/run" do
  owner node['zeppelin']['user']
  group node['zeppelin']['group']
  mode 0655
  action :create
end

directory "#{node['zeppelin']['home']}/logs" do
  owner node['zeppelin']['user']
  group node['zeppelin']['group']
  mode 0655
  action :create
end

directory "#{node['zeppelin']['home']}/Projects" do
  owner node['zeppelin']['user']
  group node['hops']['group']
  mode "0770"
  action :create
end


# Support for 'R' in apache zeppelin
case node['platform_family']
when "debian"
 package "r-base" do
  action :install
 end

when "rhel"
  package "R" do
    action :install
  end
  package "R-devel" do
    action :install
  end
  package "libcurl-devel" do
    action :install
  end
  package "openssl-devel" do
    action :install
  end
end

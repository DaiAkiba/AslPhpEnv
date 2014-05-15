#
# Cookbook Name:: asl-php-env
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#stop iptables
service "iptables" do
  action [:stop, :disable]
end

#update apt-get
execute "apt_update" do
 command "apt-get update"
 action :run
end

#install apache php
%w(apache2 php5 libapache2-mod-php5 php5-mcrypt).each do |pkg|
  package pkg do
    action :install
  end
end

#install for MS-SQL connection
%w(freetds-common freetds-bin unixodbc php5-sybase).each do |pkg|
  package pkg do
    action :install
  end
end

#apache2 default directory change
template "default" do
  path "/etc/apache2/sites-available/default"
  source "default.erb"
  mode 0644
end

#php enable on apache2
template "php5.conf" do
  path "/etc/apache2/sites-available/php5.conf"
  source "php5.conf.erb"
  mode 0644
end

#freetds setting for MS-SQL connection
template "freetds.conf" do
  path "/etc/freetds/freetds.conf"
  source "freetds.conf.erb"
  mode 0644
end

#service configuration
service "apache2" do
  supports :status => true, :restart => true
  action [:enable, :restart]
end

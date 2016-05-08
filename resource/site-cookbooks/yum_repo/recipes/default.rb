#
# Cookbook Name:: yum_repo
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
bash 'add_epel' do
  user 'root'
  code <<-ECO
    rpm -ivh http://ftp-srv2.kddilabs.jp/Linux/distributions/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
    sed -i -e "s/enabled *= *1/enabled=0/g" /etc/yum.repos.d/epel.repo
  ECO
  creates "/etc/yum.repos.d/epel.repo"
end

bash 'add_remi' do
  user 'root'
  code <<-ECO
    rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
    sed -i -e "s/enabled *= *1/enabled=0/g" /etc/yum.repos.d/remi.repo
  ECO
  creates "/etc/yum.repos.d/remi.repo"
end

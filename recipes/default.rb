# -*- coding: utf-8 -*-
#
# Cookbook Name:: omc_elasticsearch
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
include_recipe 'java'

omc_elasticsearch_node 'elasticsearch' do
  action :install
#  user 'elasticsearch'
#  group 'elasticsearch'
#  shell '/bin/bash'
  home '/opt/elasticsearch_home'
  version '1.7.1-1'
  base_url 'http://packages.elasticsearch.org/elasticsearch/1.7/centos'
  gpgkey_url 'https://packages.elasticsearch.org/GPG-KEY-elasticsearch'
  cluster_name 'kitchen-cluster01'
  install_path '/usr/share/elasticsearch'
  data_path '/data/kitchen-cluster01/data'
  log_path '/data/kitchen-cluster01/log'
  work_path '/data/kitchen-cluster01/work'
  config_path '/etc/elasticsearch'
  pid_path '/var/run/elasticsearch'
end

omc_elasticsearch_config 'elasticsearch' do
#  user 'elasticsearch'
#  group 'elasticsearch'
  cluster_name 'kitchen-cluster01'
  install_path '/usr/share/elasticsearch'
  data_path '/data/kitchen-cluster01/data'
  log_path '/data/kitchen-cluster01/log'
  work_path '/data/kitchen-cluster01/work'
  config_path '/etc/elasticsearch'
  pid_path '/var/run/elasticsearch'
  #http_port 9200
  #transport_port 9300
  node_name node.fqdn.downcase
  bind_ip '0.0.0.0'
  publish_ip '0.0.0.0'
  action :render
  elasticsearch_data_bag_info 'slapchop' => 'elasticsearch_localdev' 
  #java_opts node[:omc_slapchop][:elasticsearch][:java_opts]
  override_java_opts  '-Xmx' => '768m'
  #default_config node[:omc_slapchop][:elasticsearch][:default_config]
  override_config {}
  #default_sysconfig node[:omc_slapchop][:elasticsearch][:default_sysconfig]
  override_sysconfig 'ES_RESTART_ON_UPGRADE' => false
end

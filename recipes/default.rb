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
  version '1.7.1-1'
end

omc_elasticsearch_config 'elasticsearch' do 
  action :render
  node_list ['default-oel65-chef-java','node02']
  override_java_opts '-Xmx' => '768m'
  override_config '#icecream' => 'rocks'
end


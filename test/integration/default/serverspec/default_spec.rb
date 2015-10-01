# -*- coding: utf-8 -*-

require 'spec_helper'

describe user('elasticsearch') do
  it { should belong_to_group 'elasticsearch' }
  it { should have_home_directory '/scratch/elasticsearch_home' }
end

cluster_name = 'omc-eventstore-localdev'
install_path = '/usr/share/elasticsearch'
es_dirs = {'config_path' => '/etc/elasticsearch','data_path' => File.join('/scratch',cluster_name,'data'),'log_path' => File.join('/scratch',cluster_name,'data'),'work_path' => File.join('/scratch',cluster_name,'data'), 'pid_path' => '/var/run/elasticsearch'}

es_files = {'config.yml' => '/etc/elasticsearch/elasticsearch.yml', 'sysconfig' => '/etc/sysconfig/elasticsearch', 'initd' => '/etc/init.d/elasticsearch', 'bin.sh' => File.join(install_path,'bin/elasticsearch.in.sh')}

es_dirs.each do |k,v|
  describe file(v) do
    it { should be_directory }
    it { should be_owned_by 'elasticsearch' }
    it { should be_grouped_into 'elasticsearch' }
  end
end

es_files.each do |k,v|
  describe file(v) do
    it { should be_file }
    it { should be_owned_by 'elasticsearch' }
    it { should be_grouped_into 'elasticsearch' }
  end
end

describe service('elasticsearch') do
  it { should be_enabled }
  it { should be_running   }
end

[ 9200, 9300 ].each do |port|
  describe port(port) do
    it { should be_listening }
  end
end

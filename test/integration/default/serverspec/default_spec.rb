# -*- coding: utf-8 -*-

require 'spec_helper'

$node['omc_elasticsearch'].tap do |es|

  describe user('elasticsearch') do
    it { should belong_to_group 'elasticsearch' }
    it { should have_home_directory es['home'] }
  end

  es_dirs = {
  'data_path' => es['data_path'],
  'log_path' => es['log_path'],
  'work_path' => es['work_path'],
  'pid_path' => es['pid_path']
  }

  es_files = { 'config.yml' => '/etc/elasticsearch/elasticsearch.yml',
    'sysconfig' => '/etc/sysconfig/elasticsearch',
    'initd' => '/etc/init.d/elasticsearch',
    'bin.sh' => File.join(es['install_path'], 'bin/elasticsearch.in.sh') }


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

[ es['transport_port'], es['http_port'] ].each do |port|
  describe port(port) do
    it { should be_listening }
  end
end

end

module Elasticsearch
  module EsHelper
    def render(hash,key,separator=': ',prefix='',suffix='')
      value = hash[key]
      unless value.nil?
        if value.is_a?(Array)
          return [prefix,key,separator,value.to_s,suffix,"\n"].join
        else
          return [prefix,key,separator,value.to_s,suffix,"\n"].join
        end
        return nil
      end
    end

    def get_active_host_hash(databag)
      hosts = databag['hosts']
      active_ensemble = hosts.reject { |c| c['status'] != 'ACTIVE' }.map { |host| host['hostname'] }
    end


  end
end

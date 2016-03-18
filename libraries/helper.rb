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

    def plugin_installed?(name, es_home)
      plugin_home = ::File.join(new_resource.es_home, 'plugins')
=begin
      if File.directory?(::File.join(plugin_home, name)) 
         puts "Plugin #{name} is already installed at #{plugin_home}. Aborting..." 
         return true
      else 
         puts "Plugin #{name} is not installed at  #{plugin_home}. Ready to install..."
         return false
       end
=end
      File.directory?(::File.join(plugin_home, name)) ? true : false
    end
  end
end

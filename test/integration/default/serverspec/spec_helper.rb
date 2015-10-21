# -*- coding: utf-8 -*-

require 'serverspec'
require 'pathname'
require 'net/http'
require 'net/smtp'
require 'json'

set :backend, :exec
set :path, '$PATH:/sbin:/usr/sbin:/usr/bin:/bin'

$node = ::JSON.parse(File.read('/tmp/serverspec/node.json'))

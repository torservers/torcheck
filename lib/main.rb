#!/usr/bin/env ruby
#TorCheck  not yet daemon 
require 'optparse'
require 'yaml'
require 'pony'
require './parse.rb'
require './ssl_check.rb'

# CODES = %w[iso-2022-jp shift_jis euc-jp utf8 binary]
# CODE_ALIASES = { "jis" => "iso-2022-jp", "sjis" => "shift_jis" }

options = parse(ARGV)
config = YAML.load_file(options.config || "/etc/torcheck/torcheck.conf")

nodes = config['nodes']
nodes_down = []
global = config['global_parameters']

loop do
  nodes.each do |domain, ip| 
    puts "check: #{domain}"
    if check_status(ip, global['retries_on_fail'].to_i, global['ssl_timeout'].to_i)
      if nodes_down.include? domain
        body = "The node #{domain} with the IP #{ip} seems to be up again! Good job ;-)"
        body += "\r\n\r\nStill down are: #{nodes_down.join(', ')}" unless nodes_down.empty?
        Pony.mail(:to => global['mailto'], :from => global['mailfrom'], :subject => "Node #{domain} up again (#{nodes_down.size-1} nodes still down)", :body => body)
        nodes_down.delete domain
      end
    else # node is down!
      unless nodes_down.include? domain # if node already reported as down, ignore
        body = "The node #{domain} with the IP #{ip} seems to be down! Go and check!"
        body += "\r\n\r\nAlso down are: #{nodes_down.join(', ')}" unless nodes_down.empty?
        Pony.mail(:to => global['mailto'], :from => global['mailfrom'], :subject => "Node #{domain} down (#{nodes_down.size+1} nodes down now)", :body => body)
        nodes_down << domain
      end
    end
  end
  sleep(global['timeout_check_all'].to_i)
end

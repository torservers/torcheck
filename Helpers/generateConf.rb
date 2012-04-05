# Helper script to generate config file

require 'yaml'

config = Hash.new
config = { "nodes" => {
  "manning.torservers.net" => "173.254.192.36:443",
  "wau.torservers.net" => "109.163.233.200:443",
  "chomsky.torservers.net" => "77.247.181.162:443"
},
 "global_parameters" => {
  "checkTimeout" => "120",
  "mailto" => "admin@torservers.net",
  "mailfrom" => "hydra@torservers.net"
} }

File.open("../lib/torcheck.conf", "w") do |f|
  f.write(config.to_yaml)
end

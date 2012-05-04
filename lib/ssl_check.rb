# Actual SSL Checks go here
require 'open3'

def check_status(node, retries, timeout)
  cmdString = "echo \"EOT\\n\" | timeout #{timeout}s openssl s_client -connect " + node
  retries.times do
    stdin, stdout, stderr = Open3.popen3(cmdString)
    return true if stdout.gets != nil
  end
  return false
end

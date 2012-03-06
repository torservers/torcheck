# Actual SSL Checks go here
# TODO: Use Ruby OpenSSL gem



def check_status(node)
  cmdString = 'echo "EOT\n" | openssl s_client -connect' + node
  stdin, stdout, stderr = Open3.popen3(cmdString)
  if stdout.gets != nil
    return true
  end
end
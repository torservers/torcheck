# Actual SSL Checks go here
# TODO: Use Ruby OpenSSL gem
#TODO: Do something actually useful



def check_status(node)
  cmdString = 'echo "EOT\n" | openssl s_client -connect' + node
  stdin, stdout, stderr = Open3.popen3(cmdString)
  if stdout.gets != nil
    return true
  end
end
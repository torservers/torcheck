require 'ostruct'

#
# Return a structure describing the options.
#
def parse(args)
  # The options specified on the command line will be collected in *options*.
  # We set default values here.
  options = OpenStruct.new
  options.library = []
  options.inplace = false
  options.encoding = "utf8"
  options.transfer_type = :auto
  options.verbose = false

  opts = OptionParser.new do |opts|
    opts.banner = "Usage: example.rb [options]"

    opts.separator ""
    opts.separator "Specific options:"

    # Mandatory argument.
    opts.on("-r", "--require LIBRARY",
            "Require the LIBRARY before executing your script") do |lib|
      options.library << lib
            end

    # Optional argument; multi-line description.
    opts.on("-i", "--inplace [EXTENSION]",
            "Edit ARGV files in place",
            "  (make backup if EXTENSION supplied)") do |ext|
      options.inplace = true
      options.extension = ext || ''
      options.extension.sub!(/\A\.?(?=.)/, ".")  # Ensure extension begins with dot.
            end

    # Cast 'delay' argument to a Float.
    opts.on("--delay N", Float, "Delay N seconds between executions") do |n|
      options.delay = n
    end

    # Boolean switch.
    opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
      options.verbose = v
    end

    opts.on( '-c', '--config CONFIG', String, 'Specifiy alternative configuration file') do |conf|
      options.config = conf 
    end

    opts.separator ""
    opts.separator "Common options:"

    # No argument, shows at tail.  This will print an options summary.
    # Try it and see!
    opts.on_tail("-h", "--help", "Show this message") do
      puts opts
      exit
    end

    # Another typical switch to print the version.
    opts.on_tail("--version", "Show version") do
      puts OptionParser::Version.join('.')
      exit
    end
  end

  opts.parse!(args)
  options
end  # parse()

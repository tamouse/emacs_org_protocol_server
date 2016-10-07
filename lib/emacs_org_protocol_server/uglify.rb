require 'uglifier'

class EmacsOrgProtocolServer::Uglify

  DEFAULTS = {
    output: {
      preamble: 'javascript:'
    },
    mangle: {
      toplevel: true
    }
  }

  attr_accessor :input, :output, :options

  def initialize(input, output=nil, options=nil)
    self.input = input
    self.output = output
    self.options = DEFAULTS.merge(options || {})
  end


  def run!
    ugli = Uglifier.new(options).compile(File.read(input))
    ugli.gsub!(/\n/,'')
    if output
      File.write(output, ugli)
    else
      ugli
    end
  end

end


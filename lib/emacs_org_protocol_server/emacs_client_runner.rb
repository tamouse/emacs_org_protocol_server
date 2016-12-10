require "logger"
require "uri"

module EmacsOrgProtocolServer

  class EmacsClientRunner

    class NoParameters < RuntimeError; end

    attr_accessor :client, :logger, :location, :title, :body

    def initialize(params={}, client=nil, logger=Logger.new(STDERR))
      raise NoParameters if params.empty?
      self.logger      = logger
      self.client      = client
      self.location    = params['l'].to_s
      self.title       = params['t'].to_s
      self.body        = params['b'].to_s
    end

    def run!
      emacs_target = URI('org-protocol://capture')
      query_data = {
        template: 'w',
        url: location,
        title: title,
        body: body
      }
      query_string = URI.encode_www_form(query_data).gsub('+','%20')
      emacs_target.query = query_string

      cmd = "#{client} -n '#{emacs_target}'"
      logger.info "emacsclient command: #{cmd}"
      system(cmd)
      return ($? == 0)
    end
  end

end

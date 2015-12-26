require "emacs_org_protocol_server/version"
require 'sinatra/base'
require 'uri'

module EmacsOrgProtocolServer
  EMACSCLIENT=ENV['EMACSCLIENT'] || "/usr/local/bin/emacsclient"

  class OPServ < Sinatra::Application

    helpers do
      def esc(s)
        URI.escape(s, %r{[^[:alnum:]]})
      end
    end

    get '/' do
      if params.empty?
        return [422, 'no params passed']
      end

      p=params['p'].to_s.downcase
      if p.match(%r{capture})
        template='//w'
      else
        template=''
      end
      l=params['l'].to_s
      t=params['t'].to_s
      s=params['s'].to_s

      emacsclient_target = "org-protocol://#{p}:#{template}//#{esc(l)}/#{esc(t)}/#{esc(s)}"
      cmd = "#{EMACSCLIENT} -n '#{emacsclient_target}'"
      system(cmd)
      puts "ran #{cmd}"
      redirect to(params['l'])
    end

  end

end

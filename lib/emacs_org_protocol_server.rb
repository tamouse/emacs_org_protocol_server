require "emacs_org_protocol_server/version"
require 'emacs_org_protocol_server/uglify'
require 'emacs_org_protocol_server/emacs_client_runner'
require 'sinatra/base'
require 'uri'
require 'yaml'
require 'erb'
require 'logger'

module EmacsOrgProtocolServer

  class Settings
    attr_accessor :emacsclient, :server, :port, :bind, :config_file, :settings
    def initialize(server: '0.0.0.0', port: 4567, bind: '0.0.0.0', config_file: nil)
      self.config_file = config_file || ENV['EMACS_ORG_PROTOCOL_CONFIG'] || File.join(ENV['HOME'], '.config', 'emacs_org_protocol_server.yml')
      self.settings = {}
      if File.exist?(self.config_file)
        self.settings = YAML.load(
          ERB.new(
            File.read(self.config_file)
            ).result
          )
      end

      self.server      = ENV['EMACS_ORG_PROTOCOL_SERVER'] || settings["server"] || %w[thin mongrel webrick]
      self.port        = ENV['EMACS_ORG_PROTOCOL_PORT']   || settings["port"]   || '4567'
      self.bind        = ENV['EMACS_ORG_PROTOCOL_BIND']   || settings["bind"]   || '0.0.0.0'
      self.emacsclient = ENV['EMACSCLIENT']               || "/usr/local/bin/emacsclient"
    end
  end

  class OPServ < Sinatra::Application

    set :logger , Logger.new(STDOUT)
    logger.level = Logger::DEBUG

    settings = Settings.new
    set :server , settings.server
    set :port   , settings.port
    set :bind   , settings.bind

    helpers do
      def esc(s)
        URI.escape(s, %r{[^[:alnum:]]})
      end
    end

    get '/' do
      begin
        if EmacsOrgProtocolServer::EmacsClientRunner.new(params, settings.emacsclient, logger).run!
          redirect params['l']
        else
          [400, 'bad request']
        end
      rescue EmacsOrgProtocolServer::EmacsClientRunner::NoParameters => e
        return [400, 'bad request']
      end
    end

    get '/bookmarklet' do
      bmraw = File.expand_path('../../javascripts/bookmarklet.js', __FILE__)
      EmacsOrgProtocolServer::Uglify.new(bmraw).run!
    end

    get '/pwd' do
      "current dir is #{Dir.pwd}"
    end

    get '/public' do
      "contents of public folder: #{Dir['public/**/*'].join("\n")}"
    end
  end

end

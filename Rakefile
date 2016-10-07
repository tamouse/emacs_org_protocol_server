require "bundler/gem_tasks"
require 'emacs_org_protocol_server/uglify'

desc('Uglify the bookmarklet')
task(:uglify) do
  input = File.join(File.dirname(__FILE__), 'javascripts', 'bookmarklet.js')
  output = File.join(File.dirname(__FILE__), 'javascripts', 'bookmarklet.min.js')
  EmacsOrgProtocolServer::Uglify.new(input, output).run!
end

# The functional tests do full end-to-end testing therefore a real
# server needs to be run. Start this script before running the
# functional tests. The Rakefile does this automatically.

require 'webrick'
require 'rack'
require 'rack/showexceptions'
require 'rack/legacy'

# Keep WEBrick quiet for functional tests
class ::WEBrick::HTTPServer; def access_log(config, req, res); end end
class ::WEBrick::BasicLog; def log(level, data); end end

# Keep ShowExceptions and sub-processes quiet for functional tests
$stderr.reopen open('/dev/null', 'w')

app = Rack::Builder.app do
  use Rack::ShowExceptions
  use Rack::Legacy::Index, File.join(File.dirname(__FILE__), 'fixtures')
  use Rack::Legacy::Php, File.join(File.dirname(__FILE__), 'fixtures'), 'php', true
  use Rack::Legacy::Cgi, File.join(File.dirname(__FILE__), 'fixtures')

  run lambda { |env| [200, {'Content-Type' => 'text/html'}, ['Endpoint']] }
end
Rack::Handler::WEBrick.run app, :Port => 4000

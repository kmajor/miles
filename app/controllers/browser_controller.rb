require 'reloader/sse'

class BrowserController < ApplicationController
  include ActionController::Live

  def taco
  100.times {
      response.stream.write "hello world\n"
    }
    response.stream.close
  end

  def index
    # SSE expects the `text/event-stream` content type
    response.headers['Content-Type'] = 'text/event-stream'

    sse = Reloader::SSE.new(response.stream)

    begin
      loop do
        sse.write({ :time => Time.now })
        sleep 1
      end
    rescue IOError
      # When the client disconnects, we'll get an IOError on write
    ensure
      sse.close
    end
  end
end

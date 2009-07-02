module Basecamp
  class Connection #:nodoc:
    def initialize(master)
      @master = master
      @connection = Net::HTTP.new(master.site, master.use_ssl ? 443 : 80)
      @connection.use_ssl = master.use_ssl
      @connection.verify_mode = OpenSSL::SSL::VERIFY_NONE if master.use_ssl
    end

    def post(path, body, headers = {})
      request = Net::HTTP::Post.new(path, headers.merge('Accept' => 'application/xml'))
      request.basic_auth(@master.user, @master.password)
      @connection.request(request, body)
    end
  end
end

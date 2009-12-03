require 'fakeweb'

module IDology
  module TestHelper
    
    def fake_idology(request_type, response_name)
      request = request_type.new
      FakeWeb.register_uri(:post, 
        "#{Service.base_uri}#{request.url}", 
        :body => idology_response_path(response_name))
    end

    def idology_response_path(name)
      File.dirname(__FILE__)+"/../spec/fixtures/#{name}.xml"
    end
    
    def load_idology_response(name)
      File.read idology_response_path(name)
    end

    def parse_idology_response(name)
      Response.parse(load_idology_response(name))
    end
  end
end
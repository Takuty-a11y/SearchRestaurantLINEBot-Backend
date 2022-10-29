module Commons
  extend ActiveSupport::Concern
    def get_restaurants(query)
      searchURL = 'https://webservice.recruit.co.jp/hotpepper/gourmet/v1'
      getAPIData(searchURL, query)
    end
    def get_largeareas(query)
      largeareaURL = 'https://webservice.recruit.co.jp/hotpepper/large_area/v1'
      getAPIData(largeareaURL, query)
    end
    def get_middleareas(query)
      middleareaURL = 'http://webservice.recruit.co.jp/hotpepper/middle_area/v1'
      getAPIData(middleareaURL, query)
    end

    private
      def getAPIData(targetUrl, query)
        http_client = HTTPClient.new
        response = http_client.get(targetUrl, query)
        response = JSON.parse(response.body)
        return response['results']
      end
  end
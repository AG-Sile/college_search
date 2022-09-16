require 'faraday'

module Client
  class CollegeScorecard

    def initialize
      @client = Faraday.new(
        url: "https://api.data.gov/ed/collegescorecard/v1/",
        params: { api_key: ENV.fetch("COLLEGE_SCORECARD_API_KEY", nil) }
      )
    end


    def schools(params)
      params_with_fields = params.merge({
        _fields: "id,school.name,"
      })
      @client.get("v1/schools", params)

    end

    def schools_locations(params)
      params_with_fields = params.merge({
        _fields: "id,school.name,location"
      })
      @client.get("schools", params_with_fields)

    end
  end
end

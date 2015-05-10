module JSONHelpers
  def json_response
    response_body = response.body
    begin
      if response_body.blank?
        {}
      else
        ActiveSupport::JSON.decode(response_body).with_indifferent_access
      end
    rescue JSON::ParserError
      response_body
    end
  end
end

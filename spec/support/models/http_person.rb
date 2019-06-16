# frozen_string_literal: true

require './spec/support/models/http_json_model'

class HttpPerson < HttpJsonModel
  parse :uid
  parse :name,     path: [:personal_information]
  parse :age,      path: [:personal_information]
  parse :username, path: [:digital_information]
  parse :email,    path: [:digital_information]
end

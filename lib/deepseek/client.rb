# frozen_string_literal: true

require "faraday"

module Deepseek
  DEFAULT_URL = "https://api.deepseek.com"
  BETA_URL = "https://api.deepseek.com/beta"

  class Client
    def initialize(api_key = nil, url = DEFAULT_URL)
      @api_key = api_key || ENV.fetch("DEEPSEEK_API_KEY")
      @url = url
    end

    def self.beta
      new(nil, BETA_URL)
    end

    def chat_completions(params)
      handle_response(conn.post("chat/completions", params))
    end

    def fim_completions(params)
      handle_response(conn.post("completions", params))
    end

    def models
      handle_response(conn.get("models"))
    end

    def user_balance
      handle_response(conn.get("user/balance"))
    end

    private

    def conn
      @conn ||= Faraday.new(url: @url) do |conn|
        conn.request :json
        conn.response :json
        conn.headers["Authorization"] = "Bearer #{@api_key}"
        conn.headers["Content-Type"] = "application/json"
        conn.adapter Faraday.default_adapter
      end
    end

    def handle_response(response)
      if response.status == 200
        response.body
      else
        raise Deepseek::Error, "Request failed with status #{response.status}: #{response.body}"
      end
    end
  end
end

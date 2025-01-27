# frozen_string_literal: true

require "faraday"

module Deepseek
  class Client
    DEFAULT_BASE_URL = "https://api.deepseek.com"
    BETA_BASE_URL = "https://api.deepseek.com/beta"

    attr_reader :api_key, :base_url
    def initialize(api_key = default_api_key, base_url = default_base_url)
      @api_key = api_key || ENV.fetch("DEEPSEEK_API_KEY")
      @base_url = base_url
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
      @conn ||= Faraday.new(url: base_url) do |conn|
        conn.request :json
        conn.response :json
        conn.headers["Authorization"] = "Bearer #{api_key}"
        conn.headers["Content-Type"] = "application/json"
        conn.adapter Faraday.default_adapter
      end
    end

    def default_api_key
      ENV.fetch("DEEPSEEK_API_KEY")
    end

    def default_base_url
      DEFAULT_BASE_URL
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

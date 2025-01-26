# frozen_string_literal: true

require_relative "deepseek/version"
require_relative "deepseek/client"

module Deepseek
  class Error < StandardError; end
end

DeepSeek = Deepseek

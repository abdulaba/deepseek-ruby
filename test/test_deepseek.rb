# frozen_string_literal: true

require "test_helper"

class TestDeepseek < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Deepseek::VERSION
  end

  def test_chat_completions
    client = Deepseek::Client.new
    response = client.chat_completions(
      model: "deepseek-chat",
      messages: [{role: "user", content: "Hello, world!"}]
    )
    assert_match(/Hello/i, response.dig("choices", 0, "message", "content"))
  end

  def test_fim_completions
    client = Deepseek::Client.new(nil, Deepseek::Client::BETA_BASE_URL)
    response = client.fim_completions(
      model: "deepseek-chat",
      prompt: "The quick brown fox jumps over the lazy"
    )
    assert_match(/dog/, response.dig("choices", 0, "text"))
  end

  def test_models
    client = Deepseek::Client.new
    models = client.models
    assert_equal "list", models["object"]
  end

  def test_user_balance
    client = Deepseek::Client.new
    balance = client.user_balance
    assert_equal true, balance["is_available"]
  end

  def test_module_alias
    assert_equal Deepseek::Client, DeepSeek::Client
  end
end

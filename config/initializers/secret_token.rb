# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
if ['development', 'test'].include? Rails.env
  secret_key_base = 'decabf93f7fd8908217a4a75096534285ed82886fb9681040659795f6ae086a022d8cabd300cc051b4ff0c049cf970b6ca639fee15d2f6a779b55e1fb7e83458'
else
  secret_key_base = ENV['SECRET_KEY_BASE']
end

FourthYearProjectSystem::Application.config.secret_key_base = secret_key_base

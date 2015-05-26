require 'rubygems'
require 'bundler/setup'
require 'lotus/setup'

require 'pry'
require 'awesome_print'
AwesomePrint.pry!

require_relative '../lib/fyber_client'
require_relative '../apps/web/application'

Lotus::Container.configure do
  mount Web::Application, at: '/'
end

Oj.default_options = {
  mode: :compat,
  symbol_keys: true
}

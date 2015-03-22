require 'rails'
module Rrssb
  module Rails
    class Engine < ::Rails::Engine
      config.autoload_paths << File.expand_path("../helpers/rrssb/rails", __FILE__)
    end
  end
end
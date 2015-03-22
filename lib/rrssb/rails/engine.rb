module Rrssb
  module Rails
    class Engine < ::Rails::Engine
      config.autoload_paths << File.expand_path("../helpers/rrssb/rails", __FILE__)
      config.rrssb_rails = Rrssb::Rails::Configuration.new
    end
  end
end

require 'rails/generators/base'
require 'rails/generators/active_record'

module Rrssb
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def create_rrssb_initializer
        copy_file 'rrssb_rails.rb', 'config/initializers/rrssb_rails.rb'
      end

    end
  end
end
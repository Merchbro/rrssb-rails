module Rrssb
  module Rails
    class Configuration
      attr_writer :active_services
      attr_writer :default_share_title
      attr_accessor :facebook_app_id
      attr_accessor :icons_only

      def active_services
        @active_services or default_services
      end

      def default_services
        {
            facebook: true,
            twitter:  '@brentmulligan',
            email: true,
            googleplus: true,
            reddit: true
        }
      end

      def default_share_title
        @default_share_title or 'Check this out'
      end

    end

    # @return [Rrssb::Rails::Configuration] Rrssb's current configuration
    def self.configuration
      @configuration ||= Configuration.new
    end

    # Set Rrssb's configuration
    # @param config [Rrssb::Rails::Configuration]
    def self.configuration=(config)
      @configuration = config
    end

    # Modify Rrssb's current configuration
    # @yieldparam [Rrssb::Rails::Configuration] config current Rrssb config
    # ```
    # Rrssb::Rails.configure do |config|
    #   config.icons_only = true
    # end
    # ```
    def self.configure
      yield configuration
    end

  end
end
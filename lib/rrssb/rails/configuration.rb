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
            email: true,
            twitter:  '@brentmulligan',
            facebook: true,
            reddit: true
        }
      end

      def default_share_title
        @default_share_title or 'Check this out'
      end

    end
  end
end
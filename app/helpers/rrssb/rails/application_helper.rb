require 'open-uri'
module Rrssb
  module Rails
    module ApplicationHelper

      def rrssb_buttons(options={})
        title = rrssb_share_title(options)
        share_url = rrssb_share_url(options)
        email_subject = rrssb_email_subject(title, options)
        tweet_body = rrssb_tweet_body(title, share_url, options)
        media_url = rrssb_media_url(options)
        fb_share_endpoint = rrssb_fb_share_endpoint(share_url[:encoded])
        icon_display_class = rrssb_icon_only_mode(options[:icons_only])

        render partial: 'rrssb/rails/sharing_buttons', locals: {
                                                         active_services: rrssb_active_services,
                                                         title: title,
                                                         share_url: share_url,
                                                         tweet_body: tweet_body,
                                                         email_subject: email_subject,
                                                         media_url: media_url,
                                                         fb_share_endpoint: fb_share_endpoint
                                                         icon_display_class: icon_display_class
                                                     }
      end


      private

      def rrssb_share_url(options)
        url = options[:share_url] || request.original_url
        rrssb_string_encoded_hash(url)
      end

      def rrssb_tweet_body(title, share_url, options)
        return unless rrssb_active_services[:twitter]

        if options[:tweet_body]
          rrssb_string_encoded_hash(options[:tweet_body])
        else
          max_tweet_length = 140
          title = title[:string]
          username = rrssb_active_services[:twitter]
          url = share_url[:string]

          # If `+title+ +url+ +username+` length is not greater than
          # +max_tweet_length+ concatenate and return...Otherwise fall back to
          # `+title+ +url+`, if still too long just use `+url+` and
          # only assume it will not be too long.
          tweet_body =  if title.length + username.length + url.length <= max_tweet_length
                          "#{title} #{url} #{username}"
                        elsif title.length + url.length <= max_tweet_length
                          "#{title} #{url}"
                        else
                          url
                        end
          rrssb_string_encoded_hash(tweet_body)
        end
      end

      def rrssb_media_url(options)
        rrssb_string_encoded_hash(options[:media_url])
      end

      def rrssb_share_title(options)
        rrssb_string_encoded_hash(options[:title])
      end

      def rrssb_email_subject(title, options)
        options[:email_subject] ? rrssb_string_encoded_hash(options[:email_subject]) : title
      end

      # Facebook has a nicer share dialog if an app_id is configured.
      def rrssb_fb_share_endpoint(url_to_share)
        if rrssb_facebook_app_id
          'https://www.facebook.com/dialog/share?'\
          "app_id=#{rrssb_facebook_app_id}"\
          '&display=popup'\
          "&href=#{url_to_share}"\
          "&redirect_uri=#{url_to_share}"
        else
          'https://www.facebook.com/sharer/sharer.php?'\
          "u=#{url_to_share}"
        end
      end


      def rrssb_icon_only_mode(override)
        if ::Rails.application.config.rrssb_rails.icon_only_mode || override
          'rrssb-icon-only'
        else
          'rrssb-normal'
        end
      end
      def rrssb_facebook_app_id
        ::Rails.application.config.rrssb_rails.facebook_app_id
      end

      def rrssb_default_share_title
        rrssb_string_encoded_hash(::Rails.application.config.rrssb_rails.default_share_title)
      end

      def rrssb_active_services
        ::Rails.application.config.rrssb_rails.active_services
      end

      def rrssb_string_encoded_hash(val)
        val = '' if val.nil?
        {
            string: val,
            encoded: URI.encode(val)
        }
      end

    end
  end
end
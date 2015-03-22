require 'open-uri'
module Rrssb
  module Rails
    module ApplicationHelper

      def rrssb_share_buttons(options={})
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
                                                         fb_share_endpoint: fb_share_endpoint,
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
          tweet_body = rrssb_build_tweet(title, share_url)
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
        if ::Rrssb::Rails.configuration.icons_only || override
          'rrssb-icon-only'
        else
          'rrssb-normal'
        end
      end

      # Builds a tweet that is less than 140 chars
      # from title, share_url and username.
      # Attempts to format as `[title] [share_url] [username]`,
      # falls backs to `[title] [share_url]`, `[share_url] [username]`,
      # `[share_url]`, `[username]` or finally an empty string if username wasn't set.
      def rrssb_build_tweet(title, share_url)
        max_tweet_length = 140
        title = title[:string]
        username = rrssb_twitter_username
        url = share_url[:string]

        if title.length + url.length + (username ? username.length : 0) <= max_tweet_length
          tweet = [title, url]
          tweet << username if username
          tweet.join(' ')
        elsif title.length + url.length <= max_tweet_length
          "#{title} #{url}"
        elsif url.length + (username ? username.length : 0) <= max_tweet_length
          tweet = [url]
          tweet << username if username
          tweet.join(' ')
        elsif url.length <= max_tweet_length
          url
        elsif username
          username
        else
          ' '
        end
      end

      # Guards against misconfiguration (setting true instead of "@username" for twitter)
      # and ensures an "@" was included.
      def rrssb_twitter_username
        twitter = rrssb_active_services[:twitter]
        if twitter && twitter.class == String
          twitter.at(0) == '@' ? twitter : "@#{twitter}"
        else
          false
        end
      end
      def rrssb_facebook_app_id
        ::Rrssb::Rails.configuration.facebook_app_id
      end

      def rrssb_default_share_title
        rrssb_string_encoded_hash(::Rrssb::Rails.configuration.default_share_title)
      end

      def rrssb_active_services
        ::Rrssb::Rails.configuration.active_services
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
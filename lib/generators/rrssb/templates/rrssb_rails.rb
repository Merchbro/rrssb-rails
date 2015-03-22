# RRSSB-rails
# This gem is built on top of Ridiculously Responsive Social Sharing Buttons
# (https://github.com/kni-labs/rrssb) RRSSB is a KNI Labs freebie crafted
# by @dbox and @joshuatuscan.
# --
# Gemified (with a few slight changes) by Merchbro (merchbro.com) /
# Brent Mulligan (brent@merchbro.com / @brentmulligan)
#

Rrssb::Rails.configure do |config|
  ## Add default sharing services.
  #
  ## All available services:
  #
  # config.active_services = {
  #     facebook: true,
  #     twitter: '@brentmulligan',
  #     email: true,
  #     pinterest: true,
  #     tumblr: true,
  #     linkedin: true,
  #     googleplus: true,
  #     pocket: true,
  #     github: 'brentmulligan',
  #     reddit: true
  # }
  #
  ## => see Read Me for details on how each service is implemented.
  #
  # Only include services you need here. Value is **not** used aside
  # from Twitter & Github, details in Read Me.

  config.active_services = {
      facebook: true,
      twitter: '@your_twitter',
      email: true,
      reddit: true
  }

  # When set to true, text is hidden and icons are slightly enlarged
  # when the icons are displayed on larger screens.
  config.icons_only = false

  # Most services require a title. Default title is only used when no
  # value is passed into +rrssb_share_button+ helper.
  config.default_share_title = 'Check this out'

  # Add your App ID to use the Facebook Share Dialog
  # (https://developers.facebook.com/docs/sharing/reference/share-dialog)
  #
  config.facebook_app_id = false
end
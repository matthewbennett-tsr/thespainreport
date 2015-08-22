require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Madrid'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    
    # rewrites
    config.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
    r301 '/17504/home-secretary-fernandez-diaz-says-meeting-with-rato-was-in-no-way-secret-or-clandestine/', '/articles/65-150814103639-home-secretary-fernandez-diaz-says-meeting-with-rato-was-in-no-way-secret-or-clandestine'
    r301 '/17487/spain-jobless-total-falls-by-74028-in-july/', '/newsitems/33-150729144807-update-average-wages-in-spain-fall-slightly'
    r301 '/16953/six-year-old-boy-with-diphtheria-in-catalonia-dies/', '/articles/77-150627231118-six-year-old-boy-with-diphtheria-in-catalonia-dies'
    r301 '/16612/diphtheria-bacteria-detected-in-eight-more-children-in-catalonia/', '/articles/76-150608131147-diphtheria-detected-in-8-more-children-in-catalonia'
    r301 '/17014/spanish-air-traffic-controllers-announce-more-strike-action-to-affect-flights-on-two-weekends-in-july/', '/articles/80-150629212829-spanish-air-traffic-controllers-announce-more-strike-action-affecting-flights-on-two-weekends-in-july'
    r301 '/16643/spanish-air-traffic-strike-to-continue-on-wednesday-as-controllers-protest-abusive-service-agreement/', '/articles/79-150610105059-spanish-air-traffic-controllers-strike-to-continue-on-wednesday-over-abusive-service-agreement'
    r301 '/16604/spanish-air-traffic-controllers-begin-4-day-partial-strike-to-protest-sanctions-for-barcelona-colleagues/', '/articles/78-150608110607-spanish-air-traffic-controllers-begin-4-day-strike-in-protest-at-sanctions-for-barcelona-colleagues'
    r301 '/16649/spanish-air-traffic-controllers-non-strike-strike/', '/articles/44-150610202332-spanish-air-traffic-controllers-non-strike-strike'
    r301 '/17469/300-passengers-evacuated-after-marseille-madrid-high-speed-ave-train-catches-fire-near-lunel-france/', '/articles/1-150802130838-300-passengers-evacuated-after-marseille-madrid-high-speed-ave-train-catches-fire-in-france'
    r301 '/16963/podemos-marches-in-support-of-tspiras-greek-referendum-and-against-imf-financial-terrorism/', '/articles/81-150627205209-podemos-marches-in-support-of-tsipras-greek-referendum-and-against-imf-financial-terrorism'
    r301 '/16380/how-it-works-spanish-local-regional-elections/', '/articles/55-150523215121-how-spain-s-local-regional-elections-work'
    r301 '/16732/podemos-parties-enter-government-for-the-first-time-in-madrid-and-three-other-cities-across-spain/', '/articles/82-150613124433-podemos-parties-enter-government-for-the-first-time-in-madrid-barcelona-5-other-spanish-cities'
    r301 '/17447/catalonia-is-missing-out-on-a-huge-party/', '/articles/16-150729191902-catalonia-is-missing-out-on-a-huge-party'
    r301 '/16484/spanish-local-election-results-popular-party-wins/', '/articles/83-150524224135-spanish-local-election-results-popular-party-wins-but-loses-2-4-million-votes-compared-to-2011'
    r301 '/16747/spains-new-mayors-10-big-shifts-in-local-power-in-the-countrys-65-most-important-towns-and-cities/', '/articles/53-150613191852-spain-s-new-mayors-10-big-shifts-in-local-power-in-the-country-s-65-most-important-towns-cities'
    r301 '/17418/spains-markets-competition-commission-fines-20-car-companies-e171-million-for-cartel-practices/', '/articles/35-150728171610-spain-s-markets-competition-commission-fines-20-car-companies-171-million-for-cartel-practices'
    r301 '/16953/six-year-old-boy-with-diphtheria-in-catalonia-dies', '/articles/77-150627231118-six-year-old-boy-with-diphtheria-in-catalonia-dies'
    r301 '/16696/king-felipe-issues-royal-decree-revoking-his-sister-princess-cristinas-title-as-duchess-of-palma/', '/articles/84-150611230940-king-felipe-issues-royal-decree-revoking-his-sister-princess-cristina-s-title-as-duchess-of-palma'
    r301 '/16947/what-does-a-level-four-terror-threat-mean-in-spain/', '/articles/52-150626205103-what-does-a-level-four-terror-threat-mean-in-spain'
    r301 '/16935/spain-convenes-anti-jihadi-terror-group-meeting-after-attack-on-spanish-hotel-in-tunisia-kills-27/', '/articles/85-150626154554-spain-increases-terror-alert-level-to-high-risk-after-jihadi-attack-on-spanish-hotel-in-tunisia-kills-37'
    r301 '/17422/greek-f-16-crash-in-albacete-likely-caused-by-a-nato-checklist-moving-a-key-rudder-control-switch/', '/articles/2-150729165134-greek-f-16-crash-in-albacete-likely-caused-by-a-nato-checklist-moving-a-key-rudder-control-switch'
    r301 '/15972/is-spain-ready-for-jihadi-terror-on-the-costas/', '/articles/48-150408205644-is-spain-ready-for-jihadi-terror-on-the-costas'
    r301 '/16779/new-ahora-madrid-councillors-already-in-trouble-for-offensive-tweets-on-jews-murder-and-terror-victims/', 'xxxxxx'
    
    r301 '/category/major/politics/elections-in-spain/', '/stories/3-150726170313-spanish-general-election-2015'
    r301 '/16392/live-blog-spanish-local-regional-elections/', '/stories/34-150812205849-local-regional-elections-2015'
    
    r301 '/category/major/politics/', '/categories/1-spain-politics-government'
    r301 '/category/topics/accidents-disasters-attacks/', 'xxxxxxxx'
    r301 '/category/topics/politics-government/', 'xxxxxxxx'
    r301 '/category/topics/environment-energy-resources/', 'xxxxxxxx'
    r301 '/category/topics/diplomacy-military/', 'xxxxxxxx'
    r301 '/category/topics/economy-investment/', 'xxxxxxxx'
    r301 '/category/topics/law-order/', 'xxxxxxxx'
    r301 '/category/topics/cities-infrastructure-property/', 'xxxxxxxx'
    r301 '/category/topics/family-children-education/', 'xxxxxxxx'
    r301 '/category/topics/healthcare-medicine/', 'xxxxxxxx'
    r301 '/category/topics/media-culture-religion/', 'xxxxxxxx'
    
    r301 '/category/regions/', '/regions'
    
    r301 '/category/type/news/latest/', '/newsitems'
    r301 '/category/type/catch-up/', '/newsitems'
    r301 '/category/type/news/full/', '/articles/news'
    r301 '/category/type/editorials/', '/articles/editorial'
    r301 '/category/type/in-depth/', '/articles/in-depth'
    r301 '/category/type/comment/', '/articles/in-depth'
    r301 '/category/type/blog/', '/articles/blog'
    r301 '/category/type/video-blog/', '/articles/editorial'

    r301 '/subscribe-now/', '/subscribe/'    
    end

  end
end

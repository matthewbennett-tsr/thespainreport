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
    r301 '/8321/journalists-resign-el-jueves-suspended-el-mundo-abdication-censorship/', '/articles/98-140606022200-spanish-cartoonists-resign-and-journalists-are-suspended-after-abdication-week-censorship'
    r301 '/9248/ebola-valencia/', '/articles/99-140625132913-lab-results-negative-for-west-african-ebola-virus-in-valencia-after-health-authorities-activate-alert'
    r301 '/10252/spanish-catholic-missionary/', '/articles/100-140805193823-spanish-priest-miguel-pajares-who-tested-positive-for-ebola-in-liberia-dies-in-a-madrid-hospital'
    r301 '/10398/spanish-health-authorities-alicante-activate-alert-protocols-two-possible-ebola-cases/', '/articles/96-140816215558-spanish-health-authorities-discard-ebola-after-another-alert-over-suspected-case-in-alicante'
    r301 '/11008/artur-mas-pleads-madrid-listen-catalans-says-stopping-november-vote-impossible/', '/articles/92-140911104926-artur-mas-pleads-with-madrid-to-listen-to-catalans-says-stopping-november-vote-almost-impossible'
    r301 '/11388/47-spanish-cavers-fly-peru-race-save-injured-comrade-trapped-400m-underground-7-days/', '/articles/101-140925145000-47-spanish-cavers-race-to-peru-to-save-injured-comrade-trapped-400m-underground-for-7-days'
    r301 '/12196/poll-podemos-now-leading-force-spanish-politics-governing-popular-party-slumps-third-place/', '/articles/95-141102003355-podemos-now-leading-force-in-spanish-politics-as-popular-party-slumps-to-third-place-says-poll'
    r301 '/12436/italian-activist-injured-greenpeace-boats-rammed-spanish-navy-protecting-repsol-oil-ship/', '/articles/94-141115180323-23-yr-old-italian-activist-injured-after-spanish-navy-rams-greenpeace-boats-to-protect-repsol-oil-ship'
    r301 '/13189/popular-party-uses-majority-pass-citizens-safety-bill-opposition-parties-say-return-franco-era/', '/articles/102-141211225937-pp-uses-majority-to-pass-citizens-safety-bill-opposition-parties-say-is-return-to-franco-era'
    r301 '/13199/spanish-newspaper-publishers-association-now-asks-government-help-stop-google-news-closure/', '/articles/89-141212110913-spanish-newspaper-publishers-association-now-asks-government-to-help-stop-google-news-closure'
    r301 '/13349/catalan-police-take-anarchist-terror-group-barcelona-1000-supporters-march-protest/', '/articles/91-141216201022-catalan-police-take-down-anarchist-terror-group-in-barcelona-and-1-000-supporters-march-in-protest'
    r301 '/14036/100000-podemos-supporters-march-madrid-pablo-iglesias-praises-six-day-old-greek-government/', '/articles/103-150131174452-100-000-podemos-supporters-march-in-madrid-as-pablo-iglesias-praises-six-day-old-greek-government'
    r301 '/14180/new-metroscopia-poll-confirms-podemos-lead-collapse-support-spanish-socialist-party/', '/articles/90-150208005322-new-metroscopia-poll-confirms-podemos-lead-and-collapse-in-support-for-spanish-socialist-party'
    r301 '/14378/spains-constitutional-court-declares-november-9-independence-vote-in-catalonia-unconstitutional/', '/articles/88-150611171350-spain-s-constitutional-court-declares-catalan-preparations-for-november-9-vote-unconstitutional'
    r301 '/15622/united-left-mp-denounces-letter-threatening-new-coup-in-spain-if-podemos-government-elected/', '/articles/93-150327122923-united-left-mp-denounces-letter-threatening-new-coup-in-spain-if-podemos-government-elected'
    r301 '/15972/is-spain-ready-for-jihadi-terror-on-the-costas/', '/articles/48-150408205644-is-spain-ready-for-jihadi-terror-on-the-costas'
    r301 '/16186/government-lying-new-greenpeace-aerial-images-show-oleg-naydenov-oil-approaching-gran-canaria/', '/articles/104-150423193636-government-lying-new-greenpeace-aerial-images-show-oleg-naydenov-oil-approaching-gran-canaria'
    r301 '/16380/how-it-works-spanish-local-regional-elections/', '/articles/55-150523215121-how-spain-s-local-regional-elections-work'
    r301 '/16461/exit-polls-suggest-minority-government-or-coalitions-beckon-and-show-conflict-in-madrid-barcelona/', '/articles/97-150524210906-exit-polls-suggest-minority-government-or-coalitions-beckon-and-show-conflict-in-madrid-barcelona'
    r301 '/16484/spanish-local-election-results-popular-party-wins/', '/articles/83-150524224135-spanish-local-election-results-popular-party-wins-but-loses-2-4-million-votes-compared-to-2011'
    r301 '/16604/spanish-air-traffic-controllers-begin-4-day-partial-strike-to-protest-sanctions-for-barcelona-colleagues/', '/articles/78-150608110607-spanish-air-traffic-controllers-begin-4-day-strike-in-protest-at-sanctions-for-barcelona-colleagues'
    r301 '/16612/diphtheria-bacteria-detected-in-eight-more-children-in-catalonia/', '/articles/76-150608131147-diphtheria-detected-in-8-more-children-in-catalonia'
    r301 '/16643/spanish-air-traffic-strike-to-continue-on-wednesday-as-controllers-protest-abusive-service-agreement/', '/articles/79-150610105059-spanish-air-traffic-controllers-strike-to-continue-on-wednesday-over-abusive-service-agreement'
    r301 '/16649/spanish-air-traffic-controllers-non-strike-strike/', '/articles/44-150610202332-spanish-air-traffic-controllers-non-strike-strike'
    r301 '/16696/king-felipe-issues-royal-decree-revoking-his-sister-princess-cristinas-title-as-duchess-of-palma/', '/articles/84-150611230940-king-felipe-issues-royal-decree-revoking-his-sister-princess-cristina-s-title-as-duchess-of-palma'
    r301 '/16732/podemos-parties-enter-government-for-the-first-time-in-madrid-and-three-other-cities-across-spain/', '/articles/82-150613124433-podemos-parties-enter-government-for-the-first-time-in-madrid-barcelona-5-other-spanish-cities'
    r301 '/16747/spains-new-mayors-10-big-shifts-in-local-power-in-the-countrys-65-most-important-towns-and-cities/', '/articles/53-150613191852-spain-s-new-mayors-10-big-shifts-in-local-power-in-the-country-s-65-most-important-towns-cities'
    r301 '/16779/new-ahora-madrid-councillors-already-in-trouble-for-offensive-tweets-on-jews-murder-and-terror-victims/', '/articles/86-150613232910-ahora-madrid-councillors-already-in-trouble-for-offensive-tweets-on-jews-murder-and-terror-victims'
    r301 '/16935/spain-convenes-anti-jihadi-terror-group-meeting-after-attack-on-spanish-hotel-in-tunisia-kills-27/', '/articles/85-150626154554-spain-increases-terror-alert-level-to-high-risk-after-jihadi-attack-on-spanish-hotel-in-tunisia-kills-37'
    r301 '/16947/what-does-a-level-four-terror-threat-mean-in-spain/', '/articles/52-150626205103-what-does-a-level-four-terror-threat-mean-in-spain'
    r301 '/16953/six-year-old-boy-with-diphtheria-in-catalonia-dies', '/articles/77-150627231118-six-year-old-boy-with-diphtheria-in-catalonia-dies'
    r301 '/16953/six-year-old-boy-with-diphtheria-in-catalonia-dies/', '/articles/77-150627231118-six-year-old-boy-with-diphtheria-in-catalonia-dies'
    r301 '/16963/podemos-marches-in-support-of-tspiras-greek-referendum-and-against-imf-financial-terrorism/', '/articles/81-150627205209-podemos-marches-in-support-of-tsipras-greek-referendum-and-against-imf-financial-terrorism'
    r301 '/17014/spanish-air-traffic-controllers-announce-more-strike-action-to-affect-flights-on-two-weekends-in-july/', '/articles/80-150629212829-spanish-air-traffic-controllers-announce-more-strike-action-affecting-flights-on-two-weekends-in-july'
    r301 '/17366/polls-suggest-catalan-independence-unlikely/', '/newsitems/65-150727113325-update-polls-suggest-catalan-independence-unlikely'
    r301 '/17376/opened-in-1870-madrids-historic-cafe-comercial-announces-sudden-closure-in-facebook-message/', '/newsitems/18-150727140908-update-historic-madrid-cafe-closes'
    r301 '/17418/spains-markets-competition-commission-fines-20-car-companies-e171-million-for-cartel-practices/', '/articles/35-150728171610-spain-s-markets-competition-commission-fines-20-car-companies-171-million-for-cartel-practices'
    r301 '/17422/greek-f-16-crash-in-albacete-likely-caused-by-a-nato-checklist-moving-a-key-rudder-control-switch/', '/articles/2-150729165134-greek-f-16-crash-in-albacete-likely-caused-by-a-nato-checklist-moving-a-key-rudder-control-switch'
    r301 '/17447/catalonia-is-missing-out-on-a-huge-party/', '/articles/16-150729191902-catalonia-is-missing-out-on-a-huge-party'
    r301 '/17469/300-passengers-evacuated-after-marseille-madrid-high-speed-ave-train-catches-fire-near-lunel-france/', '/articles/1-150802130838-300-passengers-evacuated-after-marseille-madrid-high-speed-ave-train-catches-fire-in-france'
    r301 '/17475/artur-mas-calls-early-regional-elections-in-catalonia/', '/articles/6-150803212147-artur-mas-calls-early-regional-elections-in-catalonia'
    r301 '/17487/spain-jobless-total-falls-by-74028-in-july/', '/newsitems/33-150729144807-update-average-wages-in-spain-fall-slightly'
    r301 '/17504/home-secretary-fernandez-diaz-says-meeting-with-rato-was-in-no-way-secret-or-clandestine/', '/articles/65-150814103639-home-secretary-fernandez-diaz-says-meeting-with-rato-was-in-no-way-secret-or-clandestine'
    r301 '/17463/spanish-police-open-preliminary-investigation-into-corruption-crimes-at-spanish-stock-regulator-cnmv/', '/articles/31-150730112305-spanish-police-open-preliminary-investigation-into-corruption-crimes-at-stock-regulator-cnmv'
    r301 '/13954/greek-f16-crashes-spanish-air-base-albacete/', '/articles/105-150126154500-11-dead-and-20-injured-after-greek-f16-crashes-on-take-off-at-nato-air-base-in-albacete'

    r301 '/category/major/politics/elections-in-spain/', '/stories/3-150726170313-spanish-general-election-2015'
    r301 '/16392/live-blog-spanish-local-regional-elections/', '/stories/34-150812205849-local-regional-elections-2015'
    
    r301 '/category/topics/accidents-disasters-attacks/', '/categories/5-spain-accidents-disasters-attacks'
    r301 '/category/topics/cities-infrastructure-property/', '/categories/3-spain-cities-infrastructure-property'
    r301 '/category/topics/diplomacy-military/', '/categories/9-spain-diplomacy-military'
    r301 '/category/topics/economy-investment/', '/categories/2-spain-economy-investment'
    r301 '/category/topics/environment-energy-resources/', '/categories/4-spain-environment-energy-resources'
    r301 '/category/topics/law-order/', '/categories/10-spain-law-order'    
    r301 '/category/topics/family-children-education/', '/categories/7-spain-family-children-education'
    r301 '/category/topics/healthcare-medicine/', '/categories/8-spain-healthcare-medicine'
    r301 '/category/topics/media-culture-religion/', '/categories/6-spain-media-culture-religion'
    r301 '/category/major/politics/', '/categories/1-spain-politics-government'
    r301 '/category/topics/politics-government/', '/categories/1-spain-politics-government'
    
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

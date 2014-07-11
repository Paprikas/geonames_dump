require 'net/http'
require 'ruby-progressbar'
require 'activerecord-reset-pk-sequence'

namespace :geonames_dump do
  namespace :truncate do

    desc 'Truncate all geonames data.'
    #task :all => [:countries, :cities, :admin1, :admin2]
    task :all => [:countries, :features]

    desc 'Truncate admin1 codes'
    task :admin1 => :environment do
      Geonames::GeonamesAdmin1.delete_all #&& GeonamesAdmin1.reset_pk_sequence
    end

    desc 'Truncate admin2 codes'
    task :admin2 => :environment do
      Geonames::GeonamesAdmin2.delete_all #&& GeonamesAdmin2.reset_pk_sequence
    end

    desc 'Truncate cities informations'
    task :cities => :environment do
      Geonames::GeonamesCity.delete_all #&& GeonamesCity.reset_pk_sequence
    end

    desc 'Truncate countries informations'
    task :countries => :environment do
      Geonames::GeonamesCountry.delete_all && Geonames::GeonamesCountry.reset_pk_sequence
    end

    desc 'Truncate features informations'
    task :features => :environment do
      Geonames::GeonamesFeature.delete_all && Geonames::GeonamesFeature.reset_pk_sequence
    end

    desc 'Truncate alternate names'
    task :alternate_names => :environment do
      Geonames::GeonamesAlternateName.delete_all && Geonames::GeonamesAlternateName.reset_pk_sequence
    end

  end
end

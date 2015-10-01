require "geonames_dump/version"
require "geonames_dump/blocks"
require "geonames_dump/railtie" #if defined?(Rails)

module GeonamesDump
  def self.search(query, options = {})
    ret = nil

    type = options[:type] || :auto
    begin
      case type
      when :auto # return an array of features
        # city name
        ret = Geonames::GeonamesCity.geo_search(query)
        # alternate name
        ret = Geonames::GeonamesAlternateName.geo_search(query).map { |alternate| alternate.feature }.compact  if ret.blank?
        # admin1
        ret = Geonames::GeonamesAdmin1.geo_search(query) if ret.blank?
        # admin2
        ret = Geonames::GeonamesAdmin2.geo_search(query) if ret.blank?
        # feature
        ret = Geonames::GeonamesFeature.geo_search(query) if ret.blank?
      else # country, or specific type
        model = Geonames.const_get("geonames_#{type.to_s}".camelcase)
        ret = model.search(query)
      end
    rescue NameError => e
      raise $!, "Unknown type for GeonamesDump, #{$!}", $!.backtrace
    end


    ret
  end
end

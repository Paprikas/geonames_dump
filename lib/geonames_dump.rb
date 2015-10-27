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
        ret = Geonames::City.geo_search(query)
        # alternate name
        ret = Geonames::AlternateName.geo_search(query).map { |alternate| alternate.feature }.compact  if ret.blank?
        # admin1
        ret = Geonames::Admin1.geo_search(query) if ret.blank?
        # admin2
        ret = Geonames::Admin2.geo_search(query) if ret.blank?
        # feature
        ret = Geonames::Feature.geo_search(query) if ret.blank?
      else # country, or specific type
        model = Geonames.const_get("#{type.to_s}".camelcase)
        ret = model.geo_search(query)
      end
    rescue NameError => e
      raise $!, "Unknown type for GeonamesDump, #{$!}", $!.backtrace
    end


    ret
  end
end

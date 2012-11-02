#!/usr/bin/env ruby
require 'nokogiri'
require 'open-uri'
require 'active_support/core_ext/object/blank'
require 'csv'

URL = 'http://www.newyorkgasprices.com/GasPriceSearch.aspx?typ=adv&fuel=A&srch=0&station=All%20Stations'

web = Nokogiri::HTML(open(URL))

gas_stations = web.search('dl.address')

CSV.open("ny-gas.csv", "wb") do |csv|

  csv << ["name", "address", "no_gas"]

  gas_stations.each do |gas_station|

    name = gas_station.children[0].text.strip
    address = gas_station.children[2].text.strip
    no_gas = gas_station.children[4].text.strip

    csv << [name, address, no_gas.downcase.match(/no gas/).present?]
  end
end


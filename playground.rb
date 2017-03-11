require 'yaml'

# @airline
# @flight_number
# @destination
# @departure_time

flights = YAML.load_stream(File.read('flights.yaml'))

test_flight = :Trip2
airline = ''
flights.each_with_index do |ele, index|
  ele.each_pair do |k, v|
    if k == test_flight
      airline = flights[index][k][:airline]
    end
  end
end
# p flights[0][:Trip1][:airline]
p airline

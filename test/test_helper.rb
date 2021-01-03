$LOAD_PATH.unshift File.expand_path '../lib', __dir__

require 'spitewaste'
require 'minitest/autorun'
require 'minitest/pride'

FIXTURES = File.expand_path 'fixtures', __dir__

def get_fixture file
  File.read File.join FIXTURES, file
end

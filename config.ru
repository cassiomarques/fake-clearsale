$:.unshift File.dirname(File.expand_path(__FILE__)) + "/lib"
require 'fake_clearsale'
use ::Rack::ShowExceptions
run FakeClearsale::App

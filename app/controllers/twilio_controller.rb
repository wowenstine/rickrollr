class TwilioController < ApplicationController
include Webhookable

after_filter :set_header

skip_before_action: verify_authenticity_token

def voice 
  response = Twilio::TwiML::Response.new do |r|
    r.Play 'http://howenstine.co/rick_roll.mp3'
  end
  render_twiml response
end

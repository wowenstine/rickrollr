class ResponsesController < ApplicationController
  include Webhookable

  skip_before_action :require_login

  after_filter :set_header

  skip_before_action :verify_authenticity_token

  def voice
    if params['message'].present?
      # if we have a message, say it followed by the rick roll
      response = Twilio::TwiML::Response.new do |r|
        r.Say params['message'], :voice => 'alice'
        r.Play 'http://howenstine.co/rick_roll.mp3'
      end
    else
      # otherwise return the original response
      response = Twilio::TwiML::Response.new do |r|
        r.Say 'You just got Rick Rolled!', :voice => 'alice'
        r.Play 'http://linode.rabasa.com/cantina.mp3'
      end
    end

    render_twiml response
  end

end

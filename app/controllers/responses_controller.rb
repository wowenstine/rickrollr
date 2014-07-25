class ResponsesController < ApplicationController
  include Webhookable

  skip_before_action :require_login

  after_filter :set_header

  skip_before_action :verify_authenticity_token

  def create
    response = Twilio::TwiML::Response.new do |r|
      r.Say 'Hey there you just got rick rolled! Hope it didn\'t let you down', :voice => 'alice'
    end
    render_twiml response
  end
end

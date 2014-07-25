class TwilioController < ApplicationController
  include Webhookable

  after_filter :set_header

  skip_before_action :verify_authenticity_token

  def voice
    response = Twilio::TwiML::Response.new do |r|
      r.Say 'Hey there you just got rick rolled! Hope it didn\'t let you down', :voice => 'alice'
    end
    render_twiml response
  end

  ACCOUNT_SID = ENV['account_sid']
  ACCOUNT_TOKEN = ENV['auth_token']
  CALLER_ID = '13095170892'

  def makecall
    if !params['number']
      redirect_to :action => '.', 'msg' => 'Invalid phone number, ya big dummy!'
      return
    end

    # params sent to Twilio
    data = {
      :from => CALLER_ID,
      :to => params['number'],
      :url => 'http://howenstine.co/rick_roll.mp3',
      :if_machine => 'Continue'
    }

    begin
      client = Twilio::REST::Client.new(ACCOUNT_SID, ACCOUNT_TOKEN)
      client.account.calls.create(data)
    rescue StandardError => bang
      redirect_to :action => '.', 'msg' => "Error #{bang}"
      return
    end
    redirect_to root_path
  end
end

class CallsController < ApplicationController
    include Webhookable

  after_filter :set_header

  skip_before_action :verify_authenticity_token

  ACCOUNT_SID = ENV['account_sid']
  ACCOUNT_TOKEN = ENV['auth_token']
  CALLER_ID = '13095170892'

  def create
    if !params['number']
      redirect_to controller: 'homes', action: 'show', 'msg' => 'You need to enter a phone number for this work, if you get this error, you should probably quit the internet'
      return
    end
 
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
      redirect_to controller: 'homes', action: 'show', 'msg' => "Error #{bang} "
      return
    end
    redirect_to root_path
  end
end

class CallsController < ApplicationController
    include Webhookable

  after_filter :set_header

  skip_before_action :verify_authenticity_token

  ACCOUNT_SID = ENV['ACCOUNT_SID']
  ACCOUNT_TOKEN = ENV['AUTH_TOKEN']
  CALLER_ID = '13095170892'

  def create
    if params['number'].empty?
      redirect_to controller: 'homes', action: 'show', 'msg' => 'You need to enter a number' 
      return
    end
 
    data = {
      :from => CALLER_ID,
      :to => params['number'],
      :url => voice_url(:message => params['message']), 
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

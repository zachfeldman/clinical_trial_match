class AdminAlerts < ActionMailer::Base
  default :from => 'michaelwenger27@gmail.com'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def no_lat_long(postal_code)
    @postal_code = postal_code #session[:pc]
    mail( :to => ClinicalTrialMatcher::Application.config.import_report_recipient,
    :subject => 'Geocoder Failed: ' + Time.new.strftime("%m/%d/%Y %H:%M:%S") )
  end
end

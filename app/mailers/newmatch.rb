class Newmatch < ActionMailer::Base
  default :from => 'michaelwenger27@gmail.com'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def new_match_report
    @trials = Trial.all
    @sites = Site.all
    @import = Import.last
    mail( :to => ClinicalTrialMatcher::Application.config.import_report_recipient,
    :subject => 'Clinial Trial Import Report: ' + Time.new.strftime("%m/%d/%Y") )
  end
end
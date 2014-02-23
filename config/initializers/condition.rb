ClinicalTrialMatcher::Application.configure do
	config.importer_query = "brain tumor"
	config.filter_label = "I have a brain tumor"
	config.remove_unknown = "Y" # Choose either Y/N
	config.import_report_recipient = "michaelwenger27@gmail.com" # The person who will receive daily emails of what has been imported
end
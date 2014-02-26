ClinicalTrialMatcher::Application.configure do
	config.importer_query = "celiac disease"
	config.filter_label = "I have celiac disease"
	config.remove_unknown = "Y" # Choose either Y/N
	config.import_report_recipient = "michaelwenger27@gmail.com" # The person who will receive daily emails of what has been imported
end
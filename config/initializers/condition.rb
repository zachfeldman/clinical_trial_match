ClinicalTrialMatcher::Application.configure do
	config.importer_query = "spinal cord injury"
	config.filter_label = "I have a spinal cord injury"
	config.remove_unknown = "Y" # Choose either Y/N
	config.import_report_recipient = "michaelwenger27@gmail.com" # The person who will receive daily emails of what has been imported
end
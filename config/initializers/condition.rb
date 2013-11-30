ClinicalTrialMatcher::Application.configure do
	config.importer_query = "brain tumor"
	config.filter_label = "I have a brain tumor"
	config.remove_unknown = "Y" # Choose either Y/N
end
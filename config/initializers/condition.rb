ClinicalTrialMatcher::Application.configure do
	config.importer_query = "celiac disease"
	config.filter_label = "I have celiac disease"
	config.remove_unknown = "Y" # Choose either Y/N
end
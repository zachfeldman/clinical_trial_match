class ImporterController < ApplicationController
  # GET /importer
  # GET /importer/show
  def show
  	@import = Import.last
  	@trials = Trial.all
  	@sites = Site.all
  end

  # POST /importer/run
  def run
  	require 'nokogiri'
	require 'rest-client'
	require 'uri'	  	

	# HELPER METHOD FOR IDENTIFYING DIRECTORY DEPTH
	def get_from_xpath(path_and_name, directory, merge=false)
		if directory.xpath("#{path_and_name}").nil?
			return ""	
		elsif merge
			tmpValue = ""
			directory.xpath("#{path_and_name}").each do |item|
				tmpValue << item.text + ", "
			end
			return tmpValue[0..-3]
		else
			return directory.xpath("#{path_and_name}").text
		end
	end

	# HELPER METHODs FOR AGE WITH N/A VALUES
	def set_minvalue_for_age(minval)
		if minval == "N/A"
			return "0 Years"
		else
			return minval
		end
	end 

	def set_maxvalue_for_age(maxval)
		if maxval == "N/A"
			return "100 Years"
		else
			return maxval
		end
	end 

	
  	encoded_condition = URI.encode(ClinicalTrialMatcher::Application.config.importer_query)
  	remove_unknown = ClinicalTrialMatcher::Application.config.remove_unknown
	starting_url = "http://clinicaltrials.gov/ct2/results/download?down_stds=all&down_typ=study&recr=Open&no_unk=#{remove_unknown}&cond=#{encoded_condition}&show_down=Y"
	`curl "#{starting_url}" > "#{Rails.root}/tmp/trial_download.zip"`

	trial_counter = 0
	site_counter = 0

	last_import_date = Import.last.datetime unless Import.last.nil?

	Zip::Archive.open("#{Rails.root}/tmp/trial_download.zip") do |ar|
	  n = ar.num_files # number of entries
	  n.times do |i| # 5.times replace digit with number
	    entry_name = ar.get_name(i) # get entry name from archive
	    f = ar.fopen(entry_name)
	    doc = Nokogiri::XML(f)
	    root = doc.root
		temp_nct_id = get_from_xpath("//nct_id",root)

		if last_import_date.present? && (get_from_xpath("lastchanged_date",root) < last_import_date)
	 		f.close
	 	else
			@trial = Trial.where("nct_id = ?", temp_nct_id).present? ? Trial.where("nct_id = ?", temp_nct_id).first : Trial.new
			@trial.title = get_from_xpath("brief_title",root)
			@trial.description = get_from_xpath("brief_summary/textblock",root)
			@trial.detailed_description = get_from_xpath("detailed_description/textblock",root)
			@trial.sponsor = get_from_xpath("sponsors/lead_sponsor/agency",root)
			@trial.focus = get_from_xpath("condition",root,true)
			@trial.country = get_from_xpath("location_countries/country",root,true)  #redundant
			@trial.nct_id = get_from_xpath("//nct_id",root)
			@trial.official_title = get_from_xpath("official_title",root)
			@trial.agency_class = get_from_xpath("//agency_class",root)
			@trial.overall_status = get_from_xpath("//overall_status",root)
			@trial.phase = get_from_xpath("//phase",root)
			@trial.study_type = get_from_xpath("//study_type",root)
			@trial.condition = get_from_xpath("condition",root) #redundant
			@trial.inclusion = get_from_xpath("//criteria/textblock",root)
			@trial.exclusion = get_from_xpath("//criteria/textblock",root)
			@trial.gender = get_from_xpath("//gender",root)
			@trial.healthy_volunteers = get_from_xpath("//healthy_volunteers",root)
			@trial.overall_contact_name = get_from_xpath("//overall_contact/last_name",root)
			@trial.overall_contact_phone = get_from_xpath("//overall_contact/phone",root)
			@trial.overall_contact_email = get_from_xpath("//overall_contact/email",root)
			@trial.location_countries = get_from_xpath("location_countries/country",root,true)
			@trial.link_url = get_from_xpath("//link/url",root)
			@trial.link_description = get_from_xpath("//link/description",root) 
			@trial.firstreceived_date = get_from_xpath("firstreceived_date",root)
			@trial.lastchanged_date = get_from_xpath("lastchanged_date",root)
			@trial.verification_date = get_from_xpath("verification_date",root)
			@trial.keyword = get_from_xpath("keyword",root,true) 
			@trial.is_fda_regulated = get_from_xpath("is_fda_regulated",root)
		    @trial.has_expanded_access = get_from_xpath("has_expanded_access",root)

			# FOR AGE: SEPARATELY STORES IMPORTED VALUE WITH MONTHS VS ALGORITHM VALUEs
			@trial.originalminage = set_minvalue_for_age(get_from_xpath("//minimum_age",root))
			@trial.originalmaxage = set_maxvalue_for_age(get_from_xpath("//maximum_age",root))		

			doc.xpath("//location",root).each do |site|
		     	site_counter += 1
		    	@site = Site.new
		    	@site.facility = get_from_xpath("facility/name",site)
		    	@site.city = get_from_xpath("facility/address/city",site)
		    	@site.state = get_from_xpath("facility/address/state",site)
		    	@site.zip_code = get_from_xpath("facility/address/zip",site)
		    	@site.country = get_from_xpath("facility/address/country",site)
		    	@site.status = get_from_xpath("status",site)

		    	@site.contact_name = get_from_xpath("contact/last_name",site)
		    	@site.contact_phone = get_from_xpath("contact/phone",site)
		    	@site.contact_phone_ext = get_from_xpath("contact/phone_ext",site)
		    	@site.contact_phone_email = get_from_xpath("contact/email",site)

				@trial.sites << @site
				@site.save
			end


			@trial.save
			trial_counter += 1
		    f.close
		end
	    
	  end

	end


	# TIMESTAMP THE IMPORT RUN
	@import = Import.new
	@import.datetime = Time.new
	@import.valid_trials = trial_counter
	@import.valid_sites = site_counter
	@import.save

	redirect_to importer_show_path, notice: "All trials were successfully imported!"	 

  end


  def delete_all
  	@trial = Trial.delete_all
  	@sites = Site.delete_all
  	redirect_to importer_show_path, notice: "All trials and sites were deleted!"
  end

  def clear_date
  	@import = Import.new
  	@import.datetime = "Mon, 1 Jan 1900 00:00:04 UTC +00:00"
	@import.valid_trials = 0
	@import.valid_sites = 0
  	@import.save
  	redirect_to importer_show_path, notice: "The last import date was reset."
  end

  def new_match_alert
  	#UserMailer.new_match_alert.deliver
	Newmatch.new_match_report.deliver
  	redirect_to importer_show_path, notice: "Your emails were sent"
  end


end


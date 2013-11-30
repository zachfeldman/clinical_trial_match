Clinical Trial Match
=======


Project Goal
-----------
For individuals affected by a disease and interested in participating in a clinical trial, the <a href="http://clinicaltrials.gov/" target="_blank">ClinicalTrials.gov website</a> does not fully meet their needs.
* The search functionality can be confusing
* There isn't a way to find out about future trials as they become available
* Not all trials are listed on ClinicalTrials.gov 

For the Parkinson's disease community, the Michael J. Fox Foundation has developed <a href="https://foxtrialfinder.michaeljfox.org/" target="_blank">Fox Trial Finder (FTF)</a> which parses the ct.gov RSS feed for pd trials and matches volunteer accounts to trials using a matching algorithm of several data points (location, controls accepted, medications, etc).

Other disease foundations can also benefit from a tool to better promote clinical trial participation opportuities amongst their community. The goal of this open source project goal is to create a streamlined version of FTF that can be deployed to multiple foundations without large setup and maintenance overhead.

<a href="http://shrouded-river-3637.herokuapp.com/" target="_blank">Access Beta Site</a>
-----------

How to Get Involved
-----------
Pull requests are welcome!
Feel free to contact me offline at mwenger at michaeljfox.org


User Stories/Features Still Open
-----------

* CONFIG: Set up configuration so that disease condition and form inputs can flexibly be changed for future instances of the site CONDITION_TYPE = intializers/condition_type.rb   
* IMPORTER: Make sure months and years are parsed correctly
* IMPORTER: Parse inclusion exclusion criteria
* IMPORTER: Only run for modified/new trials
* IMPORTER: Open Zip files and run nightly (http://rubyzip.sourceforge.net/classes/Zip/ZipFileSystem.html). Track run times
* REGISTRATION: Complete registration process and list of matches
* REGISTRATION: Finalize email confirmation process
* EMAIL: Nightly email service hooked into importer

Phase II Items
-----------
* Import clinical trial data from more sources. <a href="http://apps.who.int/trialsearch/Default.aspx" target="_blank">http://apps.who.int/trialsearch/Default.aspx</a> - (an international version of ClinicalTrials.gov)
* Add ability for trial teams to submit their trial to be added to the site. Add admin user role to approve these submissions.
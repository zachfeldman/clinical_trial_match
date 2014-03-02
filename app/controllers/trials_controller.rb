class TrialsController < ApplicationController
  before_action :set_trial, only: [:show, :edit, :update, :destroy]

  def index

    @focuses = Focus.all

    unless params[:pc].blank?
        session[:coordinates] =  Geocoder.coordinates("#{params[:pc]}, United States")
        if session[:coordinates].nil?
          flash.now[:alert] = "We are unable to detect a zip code for your location at this time."
          AdminAlerts.no_lat_long(params[:pc]).deliver       
        end
    end

    @trials = Trial.search_for(params[:q]).age(params[:age]).control?(params[:vt]).gender(params[:gender]).type(params[:ty]).phase(params[:ph]).fda(params[:fda]).focus(params[:focus]).close_to(session[:coordinates], params[:td]).order(params[:ot]||"lastchanged_date DESC").paginate(:page => params[:page], :per_page => 10)

    # eric's refactoring recommendation -    @sites = Site.near(params[:pc],params[:td]).where(trials_ids: @trial_ids).paginate(:page => params[:page], :per_page => 10)
    session[:search_results] = request.url
    session[:age] = params[:age]
    session[:vt] = params[:vt]
    session[:gender] = params[:gender]
    session[:pc] = params[:pc]
    session[:td] = params[:td]

    # @trials.each do |trial|
    #   trial.sites.sort_by{|site| site.distance_from(session[:coordinates])}
    # end

    # rescue # Need to name raised error
    #   flash.alert = "Your zip code is not valid!"
    #   render "index"

  end


  def show
    @trial = Trial.find params[:id]
    # @TODO? I'm running distance_from in both the controller and view. Should this just be done in the model??
    if session[:coordinates]
      @sites = @trial.sites.sort_by{|site| site.distance_from(session[:coordinates])}
    else
      @sites = @trial.sites
    end



  end

  def new
    @trial = Trial.new
  end


  def edit
  end


  def create
    @trial = Trial.new(trial_params)

    respond_to do |format|
      if @trial.save
        format.html { redirect_to @trial, notice: 'Trial was successfully created.' }
        format.json { render action: 'show', status: :created, location: @trial }
      else
        format.html { render action: 'new' }
        format.json { render json: @trial.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trials/1
  # PATCH/PUT /trials/1.json
  def update
    respond_to do |format|
      if @trial.update(trial_params)
        format.html { redirect_to @trial, notice: 'Trial was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @trial.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trials/1
  # DELETE /trials/1.json
  def destroy
    @trial.destroy
    respond_to do |format|
      format.html { redirect_to trials_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_trial
    @trial = Trial.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def trial_params
    params.require(:trial).permit(:title, :description, :sponsor, :country, :focus)
  end
end

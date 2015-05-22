class UnitedsController < ApplicationController
  before_action :set_united, only: [:show, :edit, :update, :destroy]

  # GET /uniteds
  # GET /uniteds.json
  def index
    agent = Mechanize.new
    page = agent.get("http://www.united.com/web/en-US/apps/booking/flight/searchOW.aspx?CS=N")
    search_form = page.form("aspnetForm")
    origin_field = search_form.field_with(:name => "ctl00$ContentInfo$SearchForm$Airports1$Origin$txtOrigin")
    destination_field = search_form.field_with(:name => "ctl00$ContentInfo$SearchForm$Airports1$Destination$txtDestination")
    departure_date_field = search_form.field_with(:name => "ctl00$ContentInfo$SearchForm$DateTimeCabin1$Depdate$txtDptDate")
    search_type_button = search_form.radiobutton_with(:value => "rdosearchby3") 

    origin_field.value = "Madrid, Spain (MAD)"
    destination_field.value = "Denver, CO (DEN)"
    departure_date_field.value = "5/13/2015"
    search_type_button.check

    results = search_form.submit(search_form.button_with(:name=>'ctl00$ContentInfo$SearchForm$searchbutton'))
    File.write('/home/ubuntu/workspace/public/taco.html', URI.unescape(agent.page.content).force_encoding('utf-8'))

    united_availability = {:economy_saver => [], :economy_standard => [], :business_saver => [], :business_standard => [], :first_class_saver => [], :first_class_standard => []}
    united_seat_classes = [:economy_saver, :economy_standard, :business_saver, :business_standard, :first_class_saver, :first_class_standard]
    miles_data = Hash[united_seat_classes.map { | x | [x, nil] }]

    award_fields = results.parser.css('div#rewardSegments').css('div.divMileage')
    award_fields.each_with_index do |award, index|
      next if award.children.empty?
      seat_class = united_seat_classes[index % 6]
      miles_cost = award.children.first.text.split(" ")[0].sub(',','').to_i
      united_availability[seat_class] << miles_cost
    end

    united_availability.each do |category, miles| 
      miles_data[category] = miles.min
    end
    @uniteds = miles_data

  end

  # GET /uniteds/1
  # GET /uniteds/1.json
  def show
  end

  # GET /uniteds/new
  def new
    @united = United.new
  end

  # GET /uniteds/1/edit
  def edit
  end

  # POST /uniteds
  # POST /uniteds.json
  def create
    @united = United.new(united_params)

    respond_to do |format|
      if @united.save
        format.html { redirect_to @united, notice: 'United was successfully created.' }
        format.json { render :show, status: :created, location: @united }
      else
        format.html { render :new }
        format.json { render json: @united.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /uniteds/1
  # PATCH/PUT /uniteds/1.json
  def update
    respond_to do |format|
      if @united.update(united_params)
        format.html { redirect_to @united, notice: 'United was successfully updated.' }
        format.json { render :show, status: :ok, location: @united }
      else
        format.html { render :edit }
        format.json { render json: @united.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /uniteds/1
  # DELETE /uniteds/1.json
  def destroy
    @united.destroy
    respond_to do |format|
      format.html { redirect_to uniteds_url, notice: 'United was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_united
      @united = United.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def united_params
      params[:united]
    end
end

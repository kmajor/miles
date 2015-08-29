class AnalystRecordsController < ApplicationController
  before_action :set_analyst_record, only: [:show, :edit, :update, :destroy]

  # GET /analyst_records
  # GET /analyst_records.json
  def index
    @analyst_records = AnalystRecord.all
  end

  # GET /analyst_records/1
  # GET /analyst_records/1.json
  def show
  end

  # GET /analyst_records/new
  def new
    @analyst_record = AnalystRecord.new
  end

  # GET /analyst_records/1/edit
  def edit
  end

  # POST /analyst_records
  # POST /analyst_records.json
  def create
    @analyst_record = AnalystRecord.new(analyst_record_params)

    respond_to do |format|
      if @analyst_record.save
        format.html { redirect_to @analyst_record, notice: 'Analyst record was successfully created.' }
        format.json { render :show, status: :created, location: @analyst_record }
      else
        format.html { render :new }
        format.json { render json: @analyst_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /analyst_records/1
  # PATCH/PUT /analyst_records/1.json
  def update
    respond_to do |format|
      if @analyst_record.update(analyst_record_params)
        format.html { redirect_to @analyst_record, notice: 'Analyst record was successfully updated.' }
        format.json { render :show, status: :ok, location: @analyst_record }
      else
        format.html { render :edit }
        format.json { render json: @analyst_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /analyst_records/1
  # DELETE /analyst_records/1.json
  def destroy
    @analyst_record.destroy
    respond_to do |format|
      format.html { redirect_to analyst_records_url, notice: 'Analyst record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_analyst_record
      @analyst_record = AnalystRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def analyst_record_params
      params.require(:analyst_record).permit(:analyst_id, :game_date, :matchup, :selection, :line_source, :posted_time, :result, :sport_type)
    end
end

class SchoolUnitsController < ApplicationController
  before_action :set_school_unit, only: [:show, :update, :destroy]

  # GET /school_units
  def index_filtered

    @school_units = SchoolUnit.all

    render json: filtering
  end

  def index

    @school_units = SchoolUnit.all

    render json: @school_units
  end

  # GET /school_units/1
  def show
    render json: @school_unit
  end

  # POST /school_units
  def create
    @school_unit = SchoolUnit.new(school_unit_params)

    if @school_unit.save
      render json: @school_unit, status: :created, location: @school_unit
    else
      render json: @school_unit.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /school_units/1
  def update
    if @school_unit.update(school_unit_params)
      render json: @school_unit
    else
      render json: @school_unit.errors, status: :unprocessable_entity
    end
  end

  # DELETE /school_units/1
  def destroy
    @school_unit.destroy
  end

  def upload_by_file
    data = Roo::Spreadsheet.open(params[:file], extension: :xls) # open spreadsheet
    headers = data.row(1)
    # puts data.sheets

    data.each_with_pagename do |name, sheet|
      # p sheet.row(1)
      sheet.each_with_index(
        code: 'COD_SEEC', 
        description: 'UNIDADE ESCOLAR',
        address: 'ENDEREÇO', 
        cep: 'CEP', 
        phone: 'FONE', 
        fax: 'FAX', 
        email: 'EMAIL',
        category: 'CATEGORIA',
        zone: 'ZONA',
        level: 'TIPO',
        city: 'RA',
        state: 'UF',
        ) do |school_unit_data, idx|
          next if school_unit_data[:code] == nil
          next if school_unit_data[:code] == "COD_SEEC"
          # puts school_unit_data.inspect
          school_unit = SchoolUnit.new(
            code: school_unit_data[:code],
            description: school_unit_data[:description],
            address: school_unit_data[:address],
            cep: school_unit_data[:cep],
            phone: school_unit_data[:phone],
            fax: school_unit_data[:fax],
            email: school_unit_data[:email],
            category: school_unit_data[:category],
            zone: school_unit_data[:zone],
            level: school_unit_data[:level],
            city: school_unit_data[:city],
            state: school_unit_data[:state],
           )
           school_unit.save!
        end
    end

    render json: {message: 'Escolas carregadas', error: false}, status: :created
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_school_unit
      @school_unit = SchoolUnit.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def school_unit_params
      params.require(:school_unit).permit(:code, :description, :address, :cep, :phone, :fax, :email)
    end

    def filtering
      case h = params[:filter]
        when -> (h) { !h[:state].nil? }
          school_units = SchoolUnit.where(state: h[:state])
        when -> (h) { h[:category] == "SES-DF" && !h[:level].empty? && !h[:city].empty? }
          school_units = SchoolUnit.where(category: h[:category], level: h[:level], city: h[:city])
        when -> (h) { h[:category] == "UNB" || h[:category] == "IFB" }
          school_units = SchoolUnit.where(category: h[:category])
        else
          school_units = SchoolUnit.all
      end
      school_units
    end
end

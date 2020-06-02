class SchoolUnitsController < ApplicationController
  before_action :set_school_unit, only: [:show, :update, :destroy]

  # GET /school_units
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
    data = Roo::Spreadsheet.open(params[:file]) # open spreadsheet
    headers = data.row(1)

    data.each_with_index do |row, idx|
      next if idx == 0 # skip header  # create hash from headers and cells
      school_unit_data = Hash[[headers, row].transpose]  if school_unit.exists?(code: school_unit_data['COD_SEEC'])
        puts "school_unit with name '#{school_unit_data['UNIDADE ESCOLAR']}' already exists"
      next
      end
      
      school_unit = SchoolUnit.new(
        code: school_unit_data['COD_SEEC'],
        description: school_unit_data['UNIDADE_ESCOLAR'],
        address: school_unit_data['ENDEREÇO'],
        cep: school_unit_data['CEP'],
        phone: school_unit_data['FONE'],
        fax: school_unit_data['FAX'],
        email: school_unit_data['EMAIL']
      )
      school_unit.save!
    end

    render json: {data: data, message: 'Escolas carregadas', error: false}, status: :created
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
end

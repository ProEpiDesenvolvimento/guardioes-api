class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :update, :destroy, :get_path, :get_children]

  # GET /groups
  def index
    @groups = Group.all

    render json: @groups
  end

  # GET /groups/1
  def show
    render json: @group
  end

  # POST /groups
  def create
    @group = Group.new(group_params)
    if @group.save
      render json: @group, status: :created, location: @group
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /groups/1
  def update
    if @group.update(group_params)
      render json: @group
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  # GET /groups/1/get_path
  def get_path
    path = []
    begin
      path = @group.get_path(false)
    rescue
      return render json: "Could not find path", status: :unprocessable_entity
    end
    render json: path, status: :ok
  end

  # GET /groups/1/get_children
  def get_children
    is_child = @group.children_label == nil
    children = ActiveModel::SerializableResource.new(@group.children).as_json()
    render json: { is_child: is_child, children: children[:groups] }, status: :ok
  end

  # DELETE /groups/1
  def destroy
    @group.delete_subtree
  end

  # POST /groups/upload_group_file/
  def upload_group_file
    data = Roo::Spreadsheet.open(params[:file], extension: :xls) # Open spreadsheet data

    # Mandatory columns for .xls document to register new institutions
    @mandatory_columns = ["CODIGO","UNIDADE","ENDEREÇO","CEP","TELEFONE","EMAIL","PAIS","ESTADO","MUNICIPIO"]

    headers = data.row(1) # First row containing headers for table
    
    not_found_columns = validate_mandatory_columns headers
    if not_found_columns.any?
      return render json: {message: 'Mandatory table rows not found', not_found_columns: not_found_columns, error: true}, status: :unprocessable_entity
    end
    
    filter_columns = filter_columns headers

    # 3 from the 'country, state, city' filting model + the size of custom filters
    filter_size = 3 + filter_columns.length

    data.each_with_pagename do |name, sheet|
      # Turns sheet data into JSON
      sheet_data = sheet.as_json

      sheet.each_with_index(
        code: 'CODIGO', 
        description: 'UNIDADE',
        address: 'ENDEREÇO', 
        cep: 'CEP', 
        phone: 'TELEFONE',
        email: 'EMAIL',
        country: 'PAIS',
        state: 'ESTADO',
        municipality: 'MUNICIPIO'
      ) do |school_unit_data, idx|
          # Jump first index
          next if idx == 0

          # Get row from sheet
          row_data = sheet_data[idx]

          # Check if any filter data is empty and returns error if so
          skip = false
          (6..6 + filter_size - 1).each do |i|
            if row_data[i].nil? || row_data[i].empty?
              return render json: {
                message: 'Filter data is empty',
                row: idx,
                column: headers[i],
                error: true
              }, status: :unprocessable_entity
            end
          end

          print 'ADDING TO GROUPS => '
          i = 0
          row_data.each do |data|; print headers[i] + ': ' + data.to_s + ', '; i = i + 1; end;
          puts ''

        end
    end

    render json: {message: 'Escolas carregadas', error: false}, status: :created
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def group_params
      params.require(:group).permit(
        :description, 
        :children_label,
        :parent_id
      )
    end

    # Check if all required columns are present and returns the one that aren't
    def validate_mandatory_columns(headers)
      not_found_columns = []
      @mandatory_columns.each do |label|
        if !headers.include? label
          not_found_columns << label
        end
      end
      not_found_columns
    end

    # Check if all required columns are present and returns the one that aren't
    def filter_columns(headers)
      filter_columns = []
      headers.each do |header|
        if !@mandatory_columns.include? header
          filter_columns << header
        end
      end
      filter_columns
    end
end

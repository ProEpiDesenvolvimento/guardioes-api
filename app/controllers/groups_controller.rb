class GroupsController < ApplicationController
  before_action :set_group, except: [:index,:upload_group_file]
  before_action :authenticate_manager!, except: [:get_path,:get_children,:index,:show]

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
    if group_params[:description] == 'root_node'
      return render json: 'You cannot name a group \'root_node\'', status: :unprocessable_entity
    end
    @group = Group.new(group_params)
    if @group.save
      render json: @group, status: :created, location: @group
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /groups/1
  def update
    if group_params[:description] == 'root_node'
      return render json: 'You cannot name a group \'root_node\'', status: :unprocessable_entity
    end
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
    
    # If rows are not found, return error alongside missing rows
    not_found_columns = validate_mandatory_columns headers
    if not_found_columns.any?
      return render json: {message: 'Mandatory table rows not found', not_found_columns: not_found_columns, error: true}, status: :unprocessable_entity
    end
    
    filter_columns = filter_columns headers

    # 3 from the 'country, state, city' filting model + the size of custom filters
    filter_size = 3 + filter_columns.length

    rows_to_create = []

    data.each_with_pagename do |name, sheet|
      sheet_data = sheet.as_json

      sheet.each_with_index(
        code: 'CODIGO', 
        description: 'UNIDADE',
        address: 'ENDEREÇO', 
        cep: 'CEP', 
        phone: 'TELEFONE',
        email: 'EMAIL',
      ) do |group_data, idx|
          # Jump table header
          next if idx == 0

          # Get row from sheet
          row_data = sheet_data[idx]

          # List of path filters (country, state, municipality, filter_1, filter_2, ...)
          path_filter_list = (6..6+filter_size-1)

          # Check if any filter data is empty and returns error if so
          path_filter_list.each do |i|
            if row_data[i].nil? || row_data[i].empty?
              return render json: {
                message: 'Filter data is empty',
                row: idx,
                column: headers[i],
                error: true
              }, status: :unprocessable_entity
            end
          end

          path = []
          path_filter_list.each do |i|
            # If some group is called root_node, a forbidden name, return failure
            if row_data[i] == 'root_node'
              return render json: {message: 'You cannot name a group \'root_node\'', error: true}, status: :unprocessable_entity
            end
            path << {
              label: headers[i],
              description: row_data[i],
              children_label: headers[i + 1] || nil
            }
          end

          row = {
            metadata: group_data,
            path: path
          }

          rows_to_create << row
        end
    end

    rows_to_create.each do |r|
      # Set base group as current_group
      current_group = Group.find_by_description('root_node')
      r[:path].each do |p|
        # Create or add child to the path leading to the child group
        child = current_group.children.find_by_description(p[:description])
        if child.nil?
          new_group = Group.new()
          new_group.description = p[:description]
          new_group.children_label = p[:children_label]
          new_group.parent = current_group

          # If child group, add child group metadata
          if p[:children_label] == nil
              new_group.code = r[:code]
              new_group.address = r[:address]
              new_group.cep = r[:cep]
              new_group.phone = r[:phone]
              new_group.email = r[:email]
          end

          new_group.save()
          current_group = new_group
        else
          current_group = child
        end
      end
    end

    render json: {message: 'Data loaded', error: false}, status: :created
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

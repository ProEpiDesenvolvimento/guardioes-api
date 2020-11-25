class GroupsController < ApplicationController
  before_action :set_group, except: [:index,:upload_group_file,:create,:root,:build_country_city_state_groups]
  before_action :check_authenticated_admin_or_manager, except: [:get_path,:get_children,:show,:root,:get_twitter]
  before_action :validate_invalid_group_name, only: [:create,:update]
  before_action :authenticate_admin!, only: [:build_country_city_state_groups]

  MANDATORY_COLUMNS = ["CODIGO","UNIDADE","ENDEREÇO","CEP","TELEFONE","EMAIL","PAIS","ESTADO","MUNICIPIO"]
  MUNICIPALITY_INDEX = 8
  DEFAULT_FILTERS_SIZE = 3
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
    if (current_group_manager)
      ManagerGroupPermission::permit(current_group_manager, @group)
      @group.group_manager_id = current_group_manager.id
    end
    return render json: 'Not enough permissions' if !validate_manager_group_permissions
    if @group.save
      render json: @group, status: :created, location: @group
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /groups/1
  def update
    return render json: 'Not enough permissions' if !validate_manager_group_permissions
    if @group.update(group_params)
      render json: @group
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end
  
  # DELETE /groups/1
  def destroy
    @group.delete_subtree
  end

  # GET /groups/root
  def root
    return render json: Group::get_root
  end

  # GET /groups/1/get_path
  def get_path
    path = []
    path = @group.get_path(false)
    path = { "groups": [] } if path.empty?
    render json: path, status: :ok, each_serializer: GroupSimpleSerializer
  end

  # GET /groups/1/get_children
  def get_children
    is_child = @group.children_label == nil
    children = @group.children.each.map {|x| GroupSimpleSerializer.new(x) }
    render json: { label: @group.children_label, is_child: is_child, require_id: @group.require_id || false, children: children }, status: :ok
  end

  # POST /groups/upload_group_file/
  def upload_group_file(build_country_city_state_model = false)
    validate_group_manager(build_country_city_state_model); return if performed?
    data = Roo::Spreadsheet.open(params[:file], extension: :xls) # Open spreadsheet data

    headers = data.row(1) # First row containing headers for table
    
    validate_mandatory_columns headers; return if performed?

    rows_to_create = get_rows(build_country_city_state_model, headers, data); return if performed?
    create_groups(rows_to_create, build_country_city_state_model); return if performed?

    render json: {message: 'All groups created', error: false}, status: :created
  end

  # POST /groups/build_country_city_state_groups/
  # This is used only by admins to build countries, states and municipalities
  # into database with an .xls file
  def build_country_city_state_groups
    self.upload_group_file(true)
  end

  # GET /groups/:id/get_twitter
  def get_twitter
    render json: { twitter: @group.get_twitter }
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
        :parent_id,
        :code,
        :address,
        :cep,
        :phone,
        :email
      )
    end

    # Check if all required columns are present and returns the one that aren't
    def validate_mandatory_columns(headers)
      not_found_columns = []
      MANDATORY_COLUMNS.each do |label|
        if !headers.include? label
          not_found_columns << label
        end
      end
      render json: {
        message: 'Mandatory table rows not found',
        not_found_columns: not_found_columns,
        error: true
        }, status: :unprocessable_entity if not_found_columns.any?
    end

    # Check if all required columns are present and returns the one that aren't
    def filter_columns(headers)
      filter_columns = []
      headers.each do |header|
        if !MANDATORY_COLUMNS.include? header
          filter_columns << header
        end
      end
      filter_columns
    end

    def check_authenticated_admin_or_manager
      if current_admin.nil? && current_group_manager.nil?
        return render json: {}, status: :ok
      end
    end
  
    def validate_manager_group_permissions(group = @group)
      if current_group_manager != nil && !current_group_manager.is_permitted?(group)
        return false
      end
      return true
    end
    
    def validate_invalid_group_name
      if group_params[:description] == 'root_node'
        return render json: 'You cannot name a group \'root_node\'', status: :unprocessable_entity
      end
    end

    def format_sheet(sheet)
      sheet_data = sheet.as_json
      sheet_data.each_with_index do |line, i|
        line.each_with_index do |text, j|
          if text.is_a? String
            sheet_data[i][j] = text.strip
          end
        end
      end
      sheet_data
    end

    def validate_row(build_country_city_state_model, row_data, i)
      if !build_country_city_state_model && (row_data[i].nil? || row_data[i].empty?)
        render json: {
          message: 'Filter data is empty',
          row: idx,
          column: headers[i],
          error: true
        }, status: :unprocessable_entity and return
      elif build_country_city_state_model && (!row_data[i].nil? || !row_data[i].empty?)
        render json: {
          message: 'Filter data is filled',
          row: idx,
          column: headers[i],
          error: true
        }, status: :unprocessable_entity and return
      end
      # If some group is called root_node, a forbidden name, return failure
      if row_data[i] == 'root_node'
        render json: {message: 'You cannot name a group \'root_node\'', error: true}, status: :unprocessable_entity and return
      end
    end

    def fill_path(row_data, headers, build_country_city_state_model, i)
      path = []
      if i == MUNICIPALITY_INDEX && !build_country_city_state_model
        path << {
          label: headers[i],
          description: row_data[i],
          children_label: 'GRUPO'
        }
        path << {
          label: 'GRUPO',
          description: current_group_manager.group_name,
          children_label: headers[i + 1] || nil
        }
      else
        path << {
          label: headers[i],
          description: row_data[i],
          children_label: headers[i + 1] || nil
        }
      end
    end

    def validate_group_manager(build_country_city_state_model)
      if !build_country_city_state_model && current_group_manager.nil?
        render json: 'You must be a group manager to create new groups', status: :forbidden
      end
    end

    def get_rows(build_country_city_state_model, headers, data)
      rows_to_create = []
    
      filter_columns = filter_columns headers
      filter_size = DEFAULT_FILTERS_SIZE + filter_columns.length
    
      rows_to_create = []
    
      data.each_with_pagename do |name, sheet|
        sheet_data = format_sheet sheet
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
            path = []
    
            # Check if any filter data is empty and returns error if so
            path_filter_list.each do |i|
              validate_row(build_country_city_state_model, row_data, i); return if performed?
              path = fill_path row_data, headers, build_country_city_state_model, i
            end
    
            row = {
              metadata: group_data,
              path: path
            }
    
            rows_to_create << row
          end
      end
      rows_to_create
    end

    def create_groups(rows_to_create, build_country_city_state_model)
      groups_not_created = []
      rows_to_create.each do |r|
        current_group = Group::get_root
        was_created = false
        is_valid_manager = true
        r[:path].each_with_index do |p, i|
          # Create or add child to the path leading to the child group
          child = current_group.children.find_by_description(p[:description])
          if child.nil?
            # 0: Country, 1: State, 2: Municipality. Managers may not create these, only use them.
            if i <= 2 && !build_country_city_state_model
              current_group = nil
              is_valid_manager = false
              r[:reason] = 'Creating a new group for \'' + p[:label] + '\' (' + p[:description] + ') is not allowed'
              groups_not_created << r
              break
            end
            new_group = Group.new()
            new_group.description = p[:description]
            new_group.children_label = p[:children_label]
            new_group.parent = current_group
  
            # If child group, add child group metadata
            if !build_country_city_state_model && p[:children_label] == nil
              new_group.code = r[:metadata][:code]
              new_group.address = r[:metadata][:address]
              new_group.cep = r[:metadata][:cep]
              new_group.phone = r[:metadata][:phone]
              new_group.email = r[:metadata][:email]
            end
  
            # Add group manager to group
            if !build_country_city_state_model
              new_group.group_manager = current_group_manager
            end
  
            # Children label for municipality is 'GRUPO' 
            if build_country_city_state_model && i == 2
              new_group.children_label = 'GRUPO'
            end
            
            #if !validate_manager_group_permissions(new_group)
            #  current_group = nil
            #  is_valid_manager = false
            #  r[:reason] = 'Not enough permissions'
            #  groups_not_created << r
            #  break
            #end
  
            was_created = true
            new_group.save()
            current_group = new_group
          else
            current_group = child
          end
        end
        if !was_created && is_valid_manager
          r[:reason] = 'Already exists'
          groups_not_created << r
        end
      end
      if groups_not_created.any?
        return render json: {
          message: 'Some or all groups were not created',
          error: true,
          groups: groups_not_created
        }, status: :created
      end  
    end
  end
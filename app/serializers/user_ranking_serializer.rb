class UserRankingSerializer < ActiveModel::Serializer
  attributes :id, :user_name, :gender, :country, :group, :group_id, :streak, :reported_this_week,
             :created_at, :updated_at, :app_id

  def group
    if object.group.nil?
      return nil
    end
    object.group.get_path(string_only=true,labled=false).join('/')
  end
end 
  
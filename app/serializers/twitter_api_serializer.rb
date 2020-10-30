class TwitterApiSerializer < ActiveModel::Serializer
  attributes :id, :handle, :tweets

  def tweets
    return object.get_tweets
  end
end

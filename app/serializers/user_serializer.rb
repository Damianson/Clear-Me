class UserSerializer
  include JSONAPI::Serializer
  # Define the attributes of the UserSerializer class
  attributes :id, :username, :email, :gender, :date_of_birth
  attribute :created_at do |user|
    # Format the user's created_at timestamp into a specific date and time format
    user.created_at.strftime('%d-%m-%Y %H:%M:%S')
  end
end

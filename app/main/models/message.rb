class Message < Volt::Model
  own_by_user

  belongs_to :chat

  field :body, String
  field :chat_id
  validate :body, length: 2
end

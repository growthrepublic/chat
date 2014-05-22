class Conversation
  include Mongoid::Document
  include Mongoid::Timestamps

  field :subscribers, type: Array, default: []

  embeds_many :messages

  scope :subscribed_by, ->(user) { where(:subscribers.in => [user.id]) }
  scope :subscribed_by_all, ->(users) {
    where(
      :subscribers.all => users.map(&:id),
      :subscribers => { "$size" => users.count },
    )
  }

  def add_subscribers(new_subscribers)
    self.subscribers = subscribers | new_subscribers.map(&:id)
    save
  end
end
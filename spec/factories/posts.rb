# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  body       :string
#  posted_on  :date
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :post do
    association :user, factory: :user
    sequence :body do |n|
      "Body #{n}"
    end
    sequence :title do |n|
      "Title #{n}"
    end
    posted_on { Date.parse('01/01/2020') }
  end
end

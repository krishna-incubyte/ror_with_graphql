# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  dob        :date
#  first_name :string           not null
#  gender     :integer          not null
#  last_name  :string
#  role       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :user do
    sequence :first_name do |n|
      "Bruce #{n}"
    end
    last_name { 'Wayne' }
    gender { 'male' }
    role { 'admin' }
  end

  trait :with_post do
    after(:build) do |user|
      user.posts << build(:post)
    end
  end
end

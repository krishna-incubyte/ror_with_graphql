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
class User < ApplicationRecord
  has_many :posts, dependent: :destroy

  enum :gender, {
    male: 0,
    female: 1,
    non_binary: 2,
    agender: 3,
    gender_fluid: 4,
    gender_queer: 5,
    bigender: 6,
    polygender: 7,
    other: 8
  }

  enum :role, {
    admin: 0,
    client: 1,
    product_owner: 2
  }
end

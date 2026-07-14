# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  dob        :date
#  email      :string
#  first_name :string           not null
#  gender     :integer          not null
#  last_name  :string
#  role       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
  include Searchable

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


  mappings dynamic: false do
    indexes :name, type: "text", analyzer: "english" do
      indexes :keyword, type: "keyword"
    end
    indexes :dob,    type: "date", format: "yyyy-MM-dd"
    indexes :gender, type: "keyword"
    indexes :role,   type: "keyword"
    indexes :email,  type: "keyword"
  end

  def as_indexed_json(options = {})
    {
      name:   "#{first_name} #{last_name}",
      dob:    dob,
      gender: gender,
      role:   role,
      email:  email&.downcase
    }
  end
end

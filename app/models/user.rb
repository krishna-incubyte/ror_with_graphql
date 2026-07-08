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
end

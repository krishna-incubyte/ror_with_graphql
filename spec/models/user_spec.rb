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

require 'rails_helper'

RSpec.describe User, type: :model do

  context "schema" do
    [:first_name, :last_name, :email].each do |field|
      it { is_expected.to have_db_column(field).of_type :string }
    end
    [:role, :gender].each do |field|
      it { is_expected.to have_db_column(field).of_type(:integer).with_options(null: false) }
    end
    it { is_expected.to have_db_column(:dob).of_type :date }
  end

  context "associations" do
    it { is_expected.to have_many(:posts).dependent(:destroy) }
  end
end

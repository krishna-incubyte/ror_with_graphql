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

require 'rails_helper'

RSpec.describe Post, type: :model do

  context "schema" do
    [:body, :title].each do |field|
      it { is_expected.to have_db_column(field).of_type :string }
    end
    it { is_expected.to have_db_column(:posted_on).of_type :date }
    it { is_expected.to have_db_column(:user_id).of_type(:integer).with_options(null: false) }
  end

  context "associations" do
    it { is_expected.to belong_to(:user) }
  end
end
# == Schema Information
#
# Table name: users
#
#  id               :integer         not null, primary key
#  provider         :string(255)
#  uid              :string(255)
#  name             :string(255)
#  oauth_token      :string(255)
#  oauth_expires_at :datetime
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#  image            :string(255)
#  email            :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :uid

  def num_listings
    TextbookListing.search(uid_eq: uid).result.count
  end

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.image = auth.info.image
      user.email = auth.info.email
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end
end

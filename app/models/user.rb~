require 'json'
require 'set'
require 'open-uri'

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

GRAPH_API = ["https://graph.facebook.com/", "?fields=friends&access_token="]

class User < ActiveRecord::Base
  attr_accessible :name, :email, :uid
  attr_accessor :friends

  def load_friends_list
    unless friends && friends.size > 0
      begin
        friends = Set.new
        url = GRAPH_API[0] + uid + GRAPH_API[1] + oauth_token
        data = JSON.parse(open(url).read)
        data["friends"]["data"].each { |h| @friends.add h["id"] }
        friends.each { |id| puts id }
      rescue => e
        p e
      end
    end
  end

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

require 'open-uri'
require 'json'
require 'set'

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
  GRAPH_API = ["https://graph.facebook.com/", "?fields=friends&access_token="]

  attr_accessible :name, :email, :uid

  @@friends = {}

  def friends
    begin
      unless @@friends[uid]
        @@friends[uid] = Set.new
        url = GRAPH_API[0] + uid + GRAPH_API[1] + oauth_token
        data = JSON.parse(open(url).read)
        data["friends"]["data"].each { |h| @@friends[uid].add h["id"] }
        @@friends[uid]
      else
        @@friends[uid]
      end
    rescue => e
      p e
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

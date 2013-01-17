class SearchSuggestion
  def self.terms_for(prefix)
    $redis.zrevrange "search-suggestions:#{prefix.downcase}", 0, 9
  end

  def self.index_textbook_listings
    TextbookListing.find_each do |listing|
      index_term(listing.title)
      index_term(listing.author)
      listing.title.split.each { |t| index_term(t) }
      listing.author.split.each { |t| index_term(t) }
    end
  end

  def self.index_term(term)
    1.upto(term.length-1) do |n|
      prefix = term[0, n]
      $redis.zincrby "search-suggestions:#{prefix.downcase}", 1, term.downcase
    end
  end
end


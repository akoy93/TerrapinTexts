namespace :search_suggestions do
  desc "Generate search suggestions from textbook listings"
  task :index => :environment do
    SearchSuggestion.index_textbook_listings
  end
end

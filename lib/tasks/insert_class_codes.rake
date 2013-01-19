namespace :insert_class_codes do
  desc "Add class code to all textbook listings"
  task :insert => :environment do
    isbn_courses = {}
    File.readlines(Rails.root.join("lib", "tasks", "UMD_isbns.txt")).each do |line|
      isbn, courses = line.split('|')
      isbn_courses[isbn] = courses.gsub(/\,/," ") 
    end

    TextbookListing.all.each do |l|
      l.update_attribute :course, isbn_courses[l[:isbn]]
    end
  end
end

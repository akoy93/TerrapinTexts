# ruby slugbooks_scraper.rb (SCHOOL_ID)

require 'nokogiri'
require 'open-uri'

DOMAIN = "http://www.slugbooks.com"
DEPARTMENT_LISTS_FILES_URL = ["http://www.slugbooks.com/js_chg/schoolDeptList", ".js"]
DEPARTMENT_LISTS_DIRECTORY = "http://www.slugbooks.com/js_school/"
SCHOOL_LOOKUP_LIST = ["http://www.slugbooks.com/js_chg/schoolLookupList", ".js"]

# file name for department lists changes dynamically
doc = Nokogiri::HTML(open(DOMAIN))
file_id = doc.to_s.match(/schoolDeptList(\d{1,})\.js/)[1]

# school ids paired with js files for department lists
doc = Nokogiri::HTML(open(DEPARTMENT_LISTS_FILES_URL[0] + file_id + DEPARTMENT_LISTS_FILES_URL[1]))
departments_js_files = doc.inner_text.scan(/(\d{1,3})\:\s+\'(\w+\.js)\'/)
departments_js_files = Hash[*departments_js_files.flatten]

# ARGV[0] is school id
unless departments_js_files[ARGV[0].to_s]
  puts "Invalid argument #{ARGV[0]}."
  exit
end

course_code_to_title = {}

# get department lists and course lists
doc = Nokogiri::HTML(open(DEPARTMENT_LISTS_DIRECTORY + departments_js_files[ARGV[0]]))
# pair department id to unparsed text of course listings
departments = doc.inner_text.scan(/\'(\d{5})\'\:\s\[(.*?)\]\]\]/m).flatten
departments = Hash[*departments]
# generate hash of course ids to course titles
departments.each do |k,v|
  departments[k].scan(/\[(\d+)\,\s\'(.+?)\s\:/).each { |id, title| course_code_to_title[id] = title }
end
# pair department id to array of course ids
departments.each { |k,v| departments[k] = departments[k].scan(/\[(\d+)\,/).flatten }

# file name for lookup list changes dynamically
doc = Nokogiri::HTML(open(DOMAIN))
file_id = doc.to_s.match(/schoolLookupList(\d{1,})\.js/)[1]

# get school acronym
doc = Nokogiri::HTML(open(SCHOOL_LOOKUP_LIST[0] + file_id + SCHOOL_LOOKUP_LIST[1]))
line = doc.inner_text.match(/\[#{Regexp.quote(ARGV[0])}.*\]/).to_s
acronym = line.match(/\|(.*)\|/)[1].strip

threads = {}
lock = Mutex.new
isbns_to_courses = {}

# queries for each course and each department and scrapes isbns and prices
departments.each do |dept, course_list|
  threads[dept] = Thread.new do 
    course_list.each do |course|
      # get isbns and book ids
      begin
        book_query_url = "http://www.slugbooks.com/#{acronym}/#{acronym}-Booklist.html?curDept=#{dept}&curCourse=#{course}"
        course = course_code_to_title[course]
        doc = Nokogiri::HTML(open(book_query_url))
        results = doc.to_s.scan(/(\d{1,})\|(\d{13})/).uniq        
        lock.synchronize { 
          results.each { |bookid, isbn| isbns_to_courses[isbn] ? isbns_to_courses[isbn] << course : isbns_to_courses[isbn] = [course] }
          # puts book_query_url + ": " + results.join(', ') + " #{course}" 
        }
      rescue => e
        puts "1 - An error occurred. #{book_query_url}"
        p e.message
      end
    end
  end
end

threads.each_value { |t| t.join }

filename = "#{acronym}_isbns.txt"

# format courses
isbns_to_courses.each do |isbn, courses|
  courses = courses.map { |course| course.gsub(/\s+/, "") }
  isbns_to_courses[isbn] = courses
end

File.open(filename, "w") do |f|
  isbns_to_courses.each { |isbn, courses| f.puts isbn + "|" + courses.join(',') }
end

puts "\nAll isbns and prices have been successfuly written to #{filename}."


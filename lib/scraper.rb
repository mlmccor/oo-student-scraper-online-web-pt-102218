require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(html = "./fixtures/student-site/index.html")
    index = Nokogiri::HTML(open(html))
    student_hashes = []
    students = index.css("div.roster-cards-container div.student-card")
    students.each do |student_data|
      new_hash = {}
      new_hash[:name] = student_data.css("h4.student-name").text
      new_hash[:location] = student_data.css("p.student-location").text
      new_hash[:profile_url] = student_data.css("a").first['href']
      student_hashes.push(new_hash)
    end
    student_hashes
  end

  def self.scrape_profile_page(profile_url)
    new_hash = {}
    index = Nokogiri::HTML(open(profile_url))
    social_media = index.css("div.social-icon-container a")
    social_media.each do |icon|
      if icon['href'].include?('twitter')
        new_hash[:twitter] = icon['href']
      elsif icon['href'].include?('github')
        new_hash[:github] = icon['href']
      elsif icon['href'].include?('linkedin')
        new_hash[:linkedin] = icon['href']
      else
        new_hash[:blog] = icon['href']
      end
    end
    new_hash[:profile_quote] = index.css('div.vitals-text-container div.profile-quote').text
    new_hash[:bio] = index.css('div.bio-content p').text
    new_hash
  end

end


#name: css("h4.student-name").text
#location: css("p.student-location").text
#profile_url: css("a").first['href']


#twitter .css("div.social-icon-container a").first['href']
#linkedin
#github
#blog
#profile_quote
#bio

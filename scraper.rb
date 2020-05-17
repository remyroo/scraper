# frozen_string_literal: true

# inspired by https://www.youtube.com/watch?v=b3CLEUBdWwQ

require 'httparty'
require 'nokogiri'
require 'byebug'

def scraper(job_board_url:, filter_query:)
  raw_page = HTTParty.get(job_board_url + filter_query)
  parsed_page = Nokogiri::HTML(raw_page)
  job_cards = parsed_page.css('#jobsboard tr.job')

  jobs = []
  job_cards.each do |job_card|
    job = {
      title: job_card.css('td.position h2').first.text,
      company: job_card.css('td.company h3').first.text,
      url: job_board_url + job_card.css('td.source a').first.attributes['href'].value,
      post_duration: job_card.css('td.time').first.text
    }
    jobs << job
    puts "Added #{job[:title]} at #{job[:company]}"
    puts ''
  end
  puts "Total number of jobs: #{jobs.count}"
end

scraper(job_board_url: 'https://remoteok.io', filter_query: '/remote-ruby-jobs')

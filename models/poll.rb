require "nokogiri"
require "time"

class Poll
  attr_reader :title, :xml

  def initialize(xml)
    @xml = xml
    @title = @xml.css("title").text
  end

  def participants
    puts "\n\n\n#{@title}\n\n\n"
    @participants ||= @xml.css("participant").map do |participant|
      { :id => participant.css("userId").text,
        :name => participant.css("name").text,
        :email => participant.css("participantEmailAddress").text,
        :phone => participant.css("participantPhoneNumber").text,
        :poll_code => @title.split(":")[0],
        :time => (Time.parse(datetimes[participant.css("preferences option").map(&:text).index("1")]) rescue nil)
      }
    end
  end

  def datetimes
    @datetimes ||= @xml.css("options option").map do |option|
      option.get_attribute("dateTime")
    end
  end

  def self.get_poll(access_token, poll_id)
    xml = Nokogiri::XML(access_token.get("/api1/polls/#{poll_id}").body)
    Poll.new(xml)
  end
end

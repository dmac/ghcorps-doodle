class Poll
  attr_reader :title

  def initialize(xml)
    @xml = xml
    @title = @xml.css("title").text
  end

  def self.get_poll(access_token, poll_id)
    xml = Nokogiri::XML(access_token.get("/api1/polls/#{poll_id}").body)
    Poll.new(xml)
  end
end

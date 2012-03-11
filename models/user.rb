class User
  attr_reader :name

  def initialize(xml)
    @xml = xml
    @name = @xml.css("name").text
  end

  def polls
    @polls ||= @xml.css("poll").map do |poll|
      { :id => poll.css("pollId").text,
        :title => poll.css("title").text
      }
    end
  end

  def self.get_user(access_token)
    xml = Nokogiri::XML(access_token.get("/api1/user").body)
    User.new(xml)
  end
end

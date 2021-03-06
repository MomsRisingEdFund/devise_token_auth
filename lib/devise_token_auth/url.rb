module DeviseTokenAuth::Url

  def self.generate(url, params = {})
    uri = URI(url)

    res = "#{uri.scheme}://#{uri.host}"
    res += ":#{uri.port}" if (uri.port && uri.port != 80 && uri.port != 443)
    res += "#{uri.path}" if uri.path
    query = [uri.query, params.to_query].reject(&:blank?).join('&')
    res += "?#{query}"
    res += "##{uri.fragment}" if uri.fragment

    return res
  end

  def self.whitelisted?(url)
    !!DeviseTokenAuth.redirect_whitelist.find { |pattern| !!Wildcat.new(pattern).match(url) }
  end


  # wildcard convenience class
  class Wildcat
    def self.parse_to_regex(str)
      escaped = Regexp.escape(str).gsub('\*','.*?')
      Regexp.new("^#{escaped}$", Regexp::IGNORECASE)
    end

    def initialize(str)
      @regex = self.class.parse_to_regex(str)
    end

    def match(str)
      !!@regex.match(str)
    end
  end

end

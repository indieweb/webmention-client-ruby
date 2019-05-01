module Webmention
  module Registerable
    def register(klass)
      klass.mime_types.each { |mime_type| registered[mime_type] = klass }
    end

    def registered
      @registered ||= {}
    end
  end
end

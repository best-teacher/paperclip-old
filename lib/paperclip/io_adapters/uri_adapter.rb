module Paperclip
  class UriAdapter < AbstractAdapter
    def initialize(target)
      @target = open(target)
      cache_current_values
      if @target.respond_to?(:tempfile)
        @tempfile = copy_to_tempfile(@target.tempfile)
      else
        @tempfile = copy_to_tempfile(@target)
      end
    end

    private

    def cache_current_values
      @original_filename = File.basename(@target.base_uri.path)
      @content_type = @target.content_type
      @size = @target.size
    end

    def copy_to_tempfile(src)
      while data = src.read(16*1024)
        destination.write(data)
      end
      destination.rewind
      destination
    end
  end
end

Paperclip.io_adapters.register Paperclip::UriAdapter do |target|
  begin
    URI.parse(target)
  rescue URI::InvalidURIError
    false
  else
    true
  end
end

module Ask
  class Configuration
    attr_accessor :upload_whitelist

    def initialize
      @upload_whitelist = %w(jpg jpeg gif png doc docx txt pdf xls xlsx zip)
    end
  end
end
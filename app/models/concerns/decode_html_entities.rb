module DecodeHtmlEntities
  extend ActiveSupport::Concern

  included do
    before_save :decode_html_entities
  end

  def decode_html_entities
    puts "I'm Here!"
    self.class.columns_hash.each do |column_name, column_type|
      if column_type.type == :string || column_type.type == :text
        self[column_name] = CGI.unescapeHTML(self[column_name]) if self[column_name].present?
      end
    end
  end
end
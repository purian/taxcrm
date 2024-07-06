# app/models/concerns/decode_html_entities.rb
module DecodeHtmlEntities
  extend ActiveSupport::Concern

  included do
    before_save :decode_html_entities
  end

  private

  def decode_html_entities
    attributes.each do |attr_name, value|
      if value.is_a?(String) && (columns_hash[attr_name].type == :string || columns_hash[attr_name].type == :text)
        self[attr_name] = decode_html_entities_in_string(value)
      end
    end
  end

  def decode_html_entities_in_string(str)
    CGI.unescapeHTML(str)
  end
end
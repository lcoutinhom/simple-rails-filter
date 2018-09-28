module SimpleFilter
  extend ActiveSupport::Concern

  module ClassMethods

    def filter(params)
      self.where(build_params(params).reject {|k,v| v.blank?})
    end

    def single_filter(params)
      self.where(params.reject {|k,v| v.blank?})
    end

    def filter_date(field, date_range = nil, begin_date = nil, end_date = nil)

      unless date_range.blank?
        begin_date = date_range.split('-').first.strip
        end_date = date_range.split('-').last.strip
      end
      if begin_date.blank? and end_date.blank?
        return self.all
      elsif begin_date.blank?
        begin_date = end_date.to_date
      elsif end_date.blank?
        end_date = begin_date.to_date
      end

      return self.where(Hash[field, begin_date.to_date..end_date.to_date])
    end

    def build_params(params)
      filter = {}
      params.each do |k,v|
        filter[k] = {}
        v.each do |key, value|
          filter[k][key] = value unless value.blank?
        end
      end
      return filter
    end

    def search(params, value)
      unless value.blank?
        query = []
        params.each do |k|
          query.push("#{k.to_s}::text ilike '%#{value}%'")
        end
        return self.where(query.to_sentence(words_connector: 'or ', two_words_connector: 'or ', last_word_connector: 'or '))
      else
        return self.all
      end
    end
  end
end

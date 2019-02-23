module SimpleFilter
  extend ActiveSupport::Concern

  included do

    scope :search, -> (params, value) do
      unless value.blank?
        query = []
        params.each do |k|
          query.push(query_builder(k,value))
        end
        return self.where(query.to_sentence(words_connector: 'or ', two_words_connector: 'or ', last_word_connector: 'or '))
      end
    end

    scope :filter, -> (params) do
      self.where(build_params(params).reject {|k,v| v.blank?})
    end

    scope :single_filter, -> (params) do
      self.where(params.reject {|k,v| v.blank?})
    end

    scope :filter_date, -> (field, date_range = nil, begin_date = nil, end_date = nil) do
      unless date_range.blank?
        begin_date = date_range.split('-').first.strip
        end_date = date_range.split('-').last.strip
      end
      if !field.blank?  and (!begin_date.blank? and !end_date.blank?)
        if begin_date.blank?
          begin_date = end_date.in_time_zone
        elsif end_date.blank?
          end_date = begin_date.in_time_zone
        end
        return self.where(Hash[field, begin_date.in_time_zone.beginning_of_day..end_date.in_time_zone.end_of_day])
      end
    end
  end

  module ClassMethods

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

    def query_builder(k,value)
      if ActiveRecord::Base.connection.adapter_name == "PostgreSQL"
        return "unaccent(#{k.to_s}::text) ilike unaccent('%#{value}%')"
      else
        return "#{k.to_s} like '%#{value}%'"
      end
    end
  end
end

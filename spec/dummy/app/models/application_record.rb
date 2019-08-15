# frozen_string_literal: true

if defined?(ActiveRecord)
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end

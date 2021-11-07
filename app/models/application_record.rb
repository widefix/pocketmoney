class ApplicationRecord < ActiveRecord::Base
  extend Memoist
  self.abstract_class = true
end

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class  # This class serves as the base class for all models in the application
end

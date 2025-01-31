require 'rails/generators'

class ServiceGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  def create_service_file
    create_file "app/services/#{file_name}_service.rb", <<~FILE
      class #{class_name}Service
        def initialize
        end

        def call
          # Implement service logic here
        end
      end
    FILE
  end
end
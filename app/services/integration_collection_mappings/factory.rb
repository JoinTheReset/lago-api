# frozen_string_literal: true

module IntegrationCollectionMappings
  class Factory
    def self.new_instance(integration:)
      service_class(integration)
    end

    def self.service_class(integration)
      case integration&.type&.to_s
      when 'Integrations::NetsuiteIntegration'
        IntegrationCollectionMappings::NetsuiteCollectionMapping
      else
        raise(NotImplementedError)
      end
    end
  end
end

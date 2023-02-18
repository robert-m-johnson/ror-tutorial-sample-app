class HealthController < ApplicationController
  def ready
    connected = ActiveRecord::Base.connection.active?

    if connected
      head :ok
    else
      logger.warn 'Readiness check failed; DB not connected'
      head :service_unavailable
    end
  end
end

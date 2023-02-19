class HealthController < ApplicationController
  def live
    head :ok
  end

  def ready
    ActiveRecord::Base.connection.active?
  rescue ActiveRecord::NoDatabaseError => _e
    logger.warn 'Readiness check failed; DB not connected'
    head :service_unavailable
  else
    head :ok
  end
end

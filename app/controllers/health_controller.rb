class HealthController < ApplicationController
  def ready
    connected = ActiveRecord::Base.connected?

    if connected
      head :ok
    else
      head :service_unavailable
    end
  end
end

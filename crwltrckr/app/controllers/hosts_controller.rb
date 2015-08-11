class HostsController < ApplicationController
  def destroy
    @host = Host.find(params[:id])
    @host.destroy
    redirect_to(:back)
  end

  def refresh
    @host = Host.find(params[:id])
    @host.refresh_stats
    @host.refresh_cached_ages
    redirect_to(:back)
  end
end

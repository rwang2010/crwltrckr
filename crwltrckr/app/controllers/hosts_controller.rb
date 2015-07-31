class HostsController < ApplicationController
  def destroy
    @host = Host.find(params[:id])
    @host.destroy
    redirect_to(:back)
  end
end

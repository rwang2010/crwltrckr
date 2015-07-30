class HostsController < ApplicationController
  def destroy
    @host = Host.find(params[:id])
    @host.destroy
  end
end

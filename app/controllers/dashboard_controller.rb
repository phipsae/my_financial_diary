class DashboardController < ApplicationController
  def index
    @assets = policy_scope(Asset)
  end
end

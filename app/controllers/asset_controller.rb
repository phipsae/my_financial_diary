class AssetController < ApplicationController
  def index
    @assets = policy_scope(Asset)
  end

  def show
  end

  def update
  end

  def destroy
  end

  def create
  end
end

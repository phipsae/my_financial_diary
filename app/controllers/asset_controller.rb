class AssetController < ApplicationController
  def index
    @assets = policy_scope(Asset)
    # work with params
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

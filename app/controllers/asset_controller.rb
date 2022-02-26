class AssetController < ApplicationController
  def index
    @assets = policy_scope(Asset)
    asset_kind_controller = AssetKindController.new
    @categories_hash = asset_kind_controller.create_categories_hash
    if params[:query].present?
      ####### DONT FORGET CURRENT_USER!!!!! #############
      @assets = Asset.where(asset_kind: AssetKind.where(category: params[:query]))
      @category = params[:query]
      raise
    end
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

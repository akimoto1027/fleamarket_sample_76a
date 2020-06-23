class ItemsController < ApplicationController
  before_action :set_item, only: [:update, :edit, :destroy]
  before_action :set_search

  def index
    @items = Item.order('created_at DESC').limit(8)
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to items_path, notice: "出品しました"
    else
      redirect_to new_item_path, alert: "出品できません。入力必須項目を確認してください"
    end
  end

  def show
    @items = Item.includes(:images)
    @items = Item.find(params[:id])
  end
  
  def new
    @item = Item.new
    @image = Image.new
    @item.images.new
    @category_parent_array = []
    @category = Category.roots.each do |parent|
    @category_parent_array << parent.name
    end
  end

  # 親カテゴリーが選択された後に動くアクション
  def get_category_children
    #選択された親カテゴリーに紐付く子カテゴリーの配列を取得
    @category_children = Category.find(params[:parent_id]).children
  end

  def top
    @items = Item.includes(:images).order('created_at DESC').limit(4)
    @items_category = Item.where(category_id: [1...200]).includes(:images).order('created_at DESC').limit(3)
  end

  # 子カテゴリーが選択された後に動くアクション
  def get_category_grandchildren
    #選択された子カテゴリーに紐付く孫カテゴリーの配列を取得
    @category_grandchildren = Category.find(params[:child_id]).children
  end

  def search
    @search = Item.ransack(params[:q])
    @items = @search.result.order("id DESC").page(params[:page]).per(5)
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :category_id, :brand_id, :price, :condition_id, :wait, :postage, :prefecture_id, :buyer_id, :shipping_fee, :shipping_day, images_attributes: [:src, :_destroy, :id]).merge(user_id: current_user.id)  
  end
end


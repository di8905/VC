# frozen_string_literal: true
class PicturesController < ApplicationController
  def index
    @pictures = Picture.all
  end

  def new
    @picture = Picture.new
  end

  def create
    @picture = Picture.new(picture_params)
    if @picture.save
      redirect_to pictures_path
      flash[:notice] = "Your picture successfully uploaded"
    else
      render :new
    end
  end

  def show
    @picture = Picture.find(params[:id])
  end

  private

  def picture_params
    params.fetch(:picture, {}).permit(:file)
  end
end

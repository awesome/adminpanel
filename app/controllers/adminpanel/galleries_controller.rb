module Adminpanel
  class GalleriesController < Adminpanel::ApplicationController
    def index
      @galleries = Gallery.find(:all)
    end

    def show
      @gallery = Gallery.find(params[:id])
    end

    def edit
      @gallery = Gallery.find(params[:id])
    end

    def create
      @gallery = Gallery.new(params[:gallery])

      if @gallery.save
        redirect_to gallery_path(@gallery), :notice => t("gallery.success")
      else
        render 'new'
      end
    end

    def move_better
      @gallery = Gallery.find(params[:id])
      if @gallery.move_to_better_position
        flash[:success] = t("gallery.moved")
      else
        flash[:warning] = t("gallery.not-moved")
      end
        respond_to do |format|
          format.html do 
            redirect_to galleries_path 
          end
          format.js do
            @galleries = Gallery.all
            render :locals => { :galleries => @galleries }
          end
        end
    end

    def move_worst
      @gallery = Gallery.find(params[:id])
      if @gallery.move_to_worst_position
        flash[:success] = t("gallery.moved")
      else
        flash[:warning] = t("gallery.not-moved")
      end
        respond_to do |format|
          format.html do 
            redirect_to galleries_path 
          end
          format.js do
            @galleries = Gallery.all
            render :locals => { :galleries => @galleries }
          end
        end
    end

    def destroy
      @gallery = Gallery.find(params[:id])
      @gallery.destroy

      redirect_to galleries_path, :notice => t("gallery.deleted")
    end

    def update
      @gallery = Gallery.find(params[:id])
      if @gallery.update_attributes(params[:gallery])
        redirect_to gallery_path(@gallery)
      else
        render 'edit'
      end
    end

    def new
      @gallery = Gallery.new
    end
  end
end
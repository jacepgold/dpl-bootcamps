class Api::BootcampsController < ApplicationController
  before_action :set_bootcamp, except: [:index, :create]
  
  def index
    render json: Bootcamp.all
  end

  def show
    render json: @bootcamp
  end

  def create
    bootcamp = Bootcamp.new(bootcamp_params)
    if bootcamp.save
      render json: bootcamp
    else
      json_error(bootcamp)
    end
  end

  def update
    if @bootcamp.update(bootcamp_params)
      render json: @bootcamp
    else
      json_error(@bootcamp)
    end
  end

  def destroy
    @bootcamp.destroy
  end

  def add_application
    current_user.application_ids << @bootcamp.id
    current_user.save
    render json: current_user
  end

  def remove_application
    current_user.application_ids.delete @bootcamp.id
    current_user.save
    render json: current_user
  end

  private
    def set_bootcamp
      @bootcamp = Bootcamp.find(params[:id])
    end

    def bootcamp_params
      params.require(:bootcamp).permit(
        :name, :year_founded, :active, 
        :languages, :full_time_tuition_cost, 
        :part_time_tuition_cost
      )
    end
end

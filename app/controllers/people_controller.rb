# app/controllers/people_controller.rb
class PeopleController < ApplicationController
  before_action :set_person, only: [ :show, :update, :destroy ]

  # GET /people
  def index
    @people = Person.all
    render json: @people
  end

  # GET /people/:id
  def show
    render json: @person
  end

  # POST /people
  def create
    @person = Person.new(person_params)

    if @person.save
      render json: @person, status: :created, location: @person
    else
      render json: @person.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /people/:id
  def update
    if @person.update(person_params)
      render json: @person
    else
      render json: @person.errors, status: :unprocessable_entity
    end
  end

  # DELETE /people/:id
  def destroy
    @person.destroy
    head :no_content
  end

  private

  def set_person
    @person = Person.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Persona no encontrada" }, status: :not_found
  end

  # Solo permite los parámetros seguros para crear o actualizar una persona
  def person_params
    params.require(:person).permit(:name, :age, :email)
  end
end

class VisitorsController < ApplicationController
  def index
  end

  def show
  end

  def new
   @visitor = Visitor.new
   render :new 
  end

  def create
    @visitor = Visitor.create(visitor_params)
    redirect_to visitors_index_path
  end

private

def visitor_params
  params.require(:visitor).permit(:first_name, :last_name, :phone, :email, :zip, :language)
end

end

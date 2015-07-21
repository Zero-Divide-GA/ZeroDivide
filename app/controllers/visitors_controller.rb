class VisitorsController < ApplicationController
  def index
  end

  def show
  end

  def new
   @visitor = Visitor.new
   # render :new 
  end

  def create
    @visitor = Visitor.create(visitor_params)
    puts "Saving visitor"
    if @visitor.save
      # flash[:success] = "Thank you. You information has been recorded and is being reviewed by our team of professionals. An insurance expert will be contacting you shortly."
      redirect_to visitors_index_path
    else
      render 'new'
    end
  end

private

def visitor_params
  params.require(:visitor).permit(:first_name, :last_name, :phone, :email, :zip, :language)
end

end

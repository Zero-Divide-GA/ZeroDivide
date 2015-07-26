class AssistersController < ApplicationController
  def index
  end

  def show
  end

  def new
   @assister = Assister.new
   render :new 
  end

  def new_two
   @assister = Assister.new
   render :new_two
 end
 
  def new_last
   @assister = Assister.new
   render :new_last
  end

  def create
    @assister = Assister.create(visitor_params)
    puts "Saving visitor"
    if @assister.save
      # flash[:success] = "Thank you. You information has been recorded and is being reviewed by our team of professionals. An insurance expert will be contacting you shortly."
      redirect_to visitors_index_path
    else
      render 'new'
    end
  end

def assister_params
  params.require(:assister).permit(:firstname, :lastname, :phone, :email, :zip, :language, :addlanguage)
end


end

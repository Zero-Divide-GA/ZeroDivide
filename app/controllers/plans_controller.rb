class PlansController < ApplicationController
  def show
    @plan = Plan.find_by_id params[:id]
    puts ">>> got back #{session}"

    @cms_data = CmsData.make_hash
    @plan_data = @plan.extract_data_for_person(session[:consumer_info], session[:drug_info], session[:pd_info])
  end

end

class PagesController < ApplicationController
  include PlanSorter
  include ActionView::Helpers::NumberHelper
  
  @@page_data_table={
                     1 =>
                     {question_header: 'We\'ve Got You Covered', question_main: 'Your location is the first piece of information you will need to enter.',
                      next_page: 2,
                      step_index: 0,
                     },

                     2 =>
                     {question_header: "Plans Found",
                      question_main: "Find the best plan for me.",
                      next_page: 3,
                      step_index: 1,
                     },

                     3 => {
                       question_header: "Plans Found",
                       question_main: "You may be eligible for a subsidy.",
                       next_page: 4,
                       step_index: 2,
                     },

                     4 => {
                       question_header: "Plans Found",
                       question_main: "Please tell us a bit about your medical history.",

                       next_page: 5,
                       step_index: 3,
                       
                     },
                     
                     5 => {
                       is_results_page: true,
                       next_page: 5,
                       step_index: 3,
                     },
                    }
  
  def show
    @page_data[:current_page]=params[:page_id].to_i
    @page_data.merge! (@@page_data_table[@page_data[:current_page]])

    @page_data[:random_person_index]=rand(3)+1

    @page_data[:current_info]=params[:current_info] ? JSON.parse(params[:current_info]) : {}
    @page_data[:current_info][:question_header] = @page_data[:question_header]
    @page_data[:current_info].merge! build_current_info(@page_data[:current_info])

    puts ">>> session data = #{@page_data[:current_info]}"
    if @page_data[:is_results_page]
      info=@page_data[:current_info]
      state = info["state"].gsub(/\+/, ' ')
      info["age"] = info["age"]=='' ? 35 : info['age']

      county = info['county']
      # The data from HC.gov had county names in both up and down case. :)
      plans=Plan.where state: state, county: [county, county.upcase]
      @plans = plans.inject([]) do |acc, plan|
        acc << plan.extract_data_for_person(info)
        acc
      end

      @plans = sort_results(@plans)
      render 'pages/results'
    end
  end

  private
  def build_current_info(h)
    [:zip, :shop_for, :marital_status, :number_of_children, :age, :smoker, :ongoing_condition, :fave_doctor, :take_prescription, :income, :procedure_names, :drugname, :drugdosage, :drugorders ].each do |id|
      if params[id]
        h[id.to_s]=params[id]
        if id == :number_of_children
          h[id.to_s] = params[id] == '3 or more' ? 3 : params[id].to_i
        elsif id == :zip
          h['county']=ZipInfo.where(zip: params[:zip])[0].county
          # Clean up the county name, so we use it more consistently in the rest of the app
          h['county'] = (h["county"].gsub(/\+/, ' ')).gsub(/ COUNTY\s*$/i, '')
          h['county'] = (h["county"].gsub(/\+/, ' ')).gsub(/ BOROUGH\s*$/i, '')

          h['state']=ZipInfo.where(zip: params[:zip])[0].state
          h['number_of_plans']=Plan.where(state: h['state'], county: [h['county'], h['county'].upcase]).size
          h[:question_header]="#{number_with_delimiter(h['number_of_plans'])} #{h[:question_header]}"
        end
      end
    end

    h
  end
end

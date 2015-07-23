# coding: utf-8
class PagesController < ApplicationController
  include PlanSorter
  include ActionView::Helpers::NumberHelper
  include PremiumCap
  before_action :setup_page
  
  @@page_data_table={
                     1 =>
                     {question_header: '', question_subheader: '',
                      question_main: '',
                      next_page: 2,
                      step_index: 0,
                      icon_array: [['', ''], ['', ], ['', ], ['', ], 'zip.png'],
                     },

                     2 =>
                     {question_header: "Plans Found",
                      question_main: "Tell us about you and your family.",
                      prev_page: 1,
                      next_page: 3,
                      step_index: 1,
                      icon_array: [['disabled/zip.png', 'complete'], ['household.png', ], ['', ], ['', ], 'household.png'],
                     },

                     3 => {
                       question_header: "Plans Found",
                       question_main: "Save money on health insurance with a subsidy - let’s see if you qualify.",
                       prev_page: 2,
                       next_page: 4,
                       step_index: 2,
                       icon_array: [['disabled/zip.png', 'complete'], ['disabled/household.png', 'complete'], ['income.png', ], ['', ], 'income.png'],
                     },

                     4 => {
                       question_header: "Plans Found",
                       question_main: "Please tell us a bit about your medical history.",

                       prev_page: 3,
                       next_page: 5,
                       step_index: 3,
                       icon_array: [['disabled/zip.png', 'complete'], ['disabled/household.png', 'complete'], ['disabled/income.png', 'complete'], ['procedures.png', ], 'procedures.png'],                       
                     },
                     
                     5 => {
                       is_results_page: true,
                       next_page: 6,
                       step_index: 3,
                     },

                     6 => {
                       is_results_page: false,
                       next_page: 7,
                       step_index: 3,
                     },
                    }

  def show_home

    render 'show_home'
  end
  def show_blank
    if params[:mesg] == 'underconstruction'
      @page_data[:stop_message_header] = 'Traducción al Español próximamente.'
      @page_data[:stop_message_subheader] = 'Spanish translation coming soon.'
    elsif params[:mesg] == 'supportbar'
      @page_data[:stop_message_header] = ''
      @page_data[:stop_message_subheader] = 'Live chat, video tutorials, audio help, and FAQs coming soon.'
    end      
    if flash[:stop_message_subheader]
      @page_data[:blank_message] = flash[:stop_message_subheader]
    end
    render 'show_blank'
  end

  def show
    subroutes = {6 => 'show_blank', 1 => 'show_home'}

    if subroutes.keys.include? @page_data[:current_page]
      subaction = subroutes[@page_data[:current_page]]
      self.send subaction
    # else
    #   (redirect_to '/page/6' and return) if page_has_error?
      
      if @page_data[:current_page] == 4
        # We have household size and income - we can now decide if we have a medicaid referral

        # Do some math for the household size first, and update the :current_info hash value
        update_household_data
        if medicaid_referral(session[:current_info]['income'], session[:current_info]['household_size'],
                             session[:current_info]['state'])
          # Bail out now: change the page supposed to be shown to the plain message page.
          @page_data[:prev_page]=nil
          @page_data[:current_page]=6
          med_rec = Medicaid.find_by_state(session[:current_info]['state'].downcase)
          @page_data[:stop_message]="You are eligible for Medicaid. Please use your <a href='#{med_rec.url}'>state's Medicaid website</a> to purchase health insurance instead. You can also contact them at <strong>#{med_rec.phone} </strong><span class='fineprint-text'>(<a href='/?null_session=1'>start over</a>)</span>."
          render 'show' and return
        end
      end

      if session[:current_info]['number_of_plans'] == 0
        # Bail out now: change the page supposed to be shown to the plain message page.
        @page_data[:prev_page]=nil
        @page_data[:current_page]=6
        @page_data[:stop_message]="Sorry, there are no plans for your state in the federal exchange - you have to use your state's exchange instead."
        render 'show' and return
      end

      if @page_data[:is_results_page]
        # This is a bit redundant but left over from old code. :(
        session[:consumer_info] = info = session[:current_info]

        state = info["state"].gsub(/\+/, ' ')
        info["age"] = info["age"]=='' ? 35 : info['age']

        # We might have reached here through a refresh of the results page, which would require household data math to be
        # redone.
        update_household_data
        subsidy_cap = calculate_premium_cap(info['income'], info['household_size'], info['state'])
        if subsidy_cap == -1
          info['subsidy'] = 0
        else
          silver_plan_2 = Plan.subsidy_cap_plan_premium(session[:plans], info)
          puts ">>> you shdn't get charged more than #{subsidy_cap} when you try to pay for #{silver_plan_2}"
          info['subsidy'] = (silver_plan_2 - subsidy_cap < 0) ? silver_plan_2 : (silver_plan_2 - subsidy_cap)
        end

        county = info['county']

        goodrx_prices=nil
        if info['take_prescription'] == 'Yes'
          goodrx_prices = GoodRx::ApiWrappers.compare_price(info['drugnames'][0])
          goodrx_prices[:drug_base_cost] = drug_expense(goodrx_prices, info)
          goodrx_prices[:is_specialty] = SpecialtyDrug.is_drug?(info['drugnames'][0])
          puts ">>> Base cost is #{goodrx_prices[:drug_base_cost]}"
          session[:drug_info] = goodrx_prices
        end

        pokitdok_prices = nil
        if info['procedure_names']
          info['procedure_orders']='1'
          cpt_codes = info['procedure_names'].split(',').map do |cpt_id|
            # Some maps don't have a code? Maybe.
            CptCodeMap.find(cpt_id.to_i).try(:cpt_code)
          end
          if !cpt_codes.compact.empty?
            pokitdok_prices = cpt_codes.map { |code| PokitdokApi::ApiWrappers.price_search(code, info['zip']) }
            session[:pd_info] = pokitdok_prices
          end
        end

        # If the user is logged in, let's put all this data into their profile
        if current_user
          if !current_user.profile
            current_user.build_profile
          end
          # This will save the user's profile
          current_user.profile.update_data(session)
        end

        # The data from HC.gov had county names in both up and down case. :)
        puts ">>> using in extraction = #{info}"
        plans=session[:plans]
        @plans = plans.inject([]) do |acc, plan|
          acc << plan.extract_data_for_person(info, goodrx_prices, pokitdok_prices)
          acc
        end
        @plans = sort_results(@plans)

        if current_user
          @current_profile = current_user.profile
        else
          @current_profile = nil
        end
        
        render 'pages/results' and return
      end
    end

  end

  private
  def page_has_error?
    has_error = false
    # Second page - error handling for tricky zips
    if @page_data[:current_page] == 2 && ZipInfo.none_or_no_county?(session[:current_info]['zip'])
      has_error=true
      flash[:stop_message_subheader] = 'The ZIP Code does not exist or is a US Territory. If a US territory, please check with your territory\'s government offices to learn about Medicaid, CHIP, and other health care options.'
    end
    if @page_data[:current_page] == 3
      age = session[:current_info]['age'].to_i 
      if age < 18 || age > 65
        has_error = true
        # Bail out now: change the page supposed to be shown to the plain message page.
        flash[:stop_message_subheader]= age<18 ? "You must be 18 or older to apply for insurance." : "You are eligible for Medicare. Please purchase your health insurance through Medicare </strong><span class='fineprint-text'>(<a href='/?null_session=1'>start over</a>)</span>."
      end
    end

    has_error
  end

  def setup_page
    @page_data[:current_page]=!(params[:page_id].blank?) ? params[:page_id].to_i : 1
    @page_data[:random_person_index]=rand(3)+1

    # We can destroy the session from the root page, if a special parameter is set
    if @page_data[:current_page] == 1 && params[:null_session]
      null_session
    end
    
    @page_data.merge! (@@page_data_table[@page_data[:current_page]])
    # Put the current info into the session
    build_current_info
  end

  def build_current_info
    # Update the session
    session[:current_info] ||= {}
    
    [:zip, :marital_status, :number_of_adults, :number_of_children, :age, :smoker, :ongoing_condition, :fave_doctor, :take_prescription, :income, :procedure_names, :drugnames, :drugdosage, :drugorders ].each do |id|
      if params[id]
        session[:current_info][id.to_s]=params[id]
        if id == :number_of_children || id == :number_of_adults
          session[:current_info][id.to_s] = params[id].to_i
        elsif id == :zip && @page_data[:current_page]==2 # only recompute state when reaching the second form page

          zip_rec=ZipInfo.where(zip: params['zip'])[0]
          unless zip_rec.nil?
            session[:current_info]['county']=zip_rec.county
            # Clean up the county name, so we use it more consistently in the rest of the app
            session[:current_info]['county'] = (session[:current_info]["county"].gsub(/\+/, ' ')).gsub(/ COUNTY\s*$/i, '').
                                               gsub(/ BOROUGH\s*$/i, '').
                                               gsub(/ PARISH\s*$/i, '').
                                               gsub(/ CENSUS AREA\s*$/i, '').
                                               gsub(/ DISTRICT OF COLUMBIA\s*$/i, '')

            session[:current_info]['state']=zip_rec.state
            session[:plans] = get_plans_from_zip(session[:current_info])
            session[:current_info]['number_of_plans']=session[:plans].size
          end
        end
      end
    end

    unless @page_data[:current_page]==1
      @page_data[:question_header]="#{number_with_delimiter(session[:current_info]['number_of_plans'])} #{@page_data[:question_header]}"
    end
  end

  def get_plans_from_zip(info)
    ps=Plan.where(state: info['state'].downcase, county: (info['county'].downcase))
    if ps.size > 0
      # Found plans in the original data with the county information
      puts ">>> Found #{ps.size} in HC plans"
      return ps
    end

    puts ">>> trying rating area"
    # Let's try getting it from rating area
    ras = RatingArea.where(zip_code: info['zip'])
    ps=Plan.where(rating_area: ras.pluck(:rating_area), state: info['state'].downcase)
    ps
  end
  
  def drug_expense(drug_info, consumer_info)

    # If the consumer gave a brand name, then the actual cost is the brand cost, else it's the generic cost.
    if drug_info[:generic_name] != consumer_info['drugnames'][0]
      actual_cost = drug_info[:brand_prices][0].to_f * consumer_info['drugdosage'].to_f * consumer_info['drugorders'].to_f
    else
      # We might get here if the consumer gave us a generic name, but Goodrx failed to give us a generic price
      actual_cost = drug_info[:generic_prices][0].to_f * consumer_info['drugdosage'].to_f * consumer_info['drugorders'].to_f
    end

    actual_cost
  end

  def update_household_data
    # Do some conversions from browser-entered data to internal formats
    if session[:current_info]['income'].is_a? String
      mod_str = session[:current_info]['income'].gsub(',', '')
      session[:current_info]['income'] = /^s*$/.match(mod_str) ? -1 : mod_str.to_f
    end
    session[:current_info]['family_number'] ||= 0
    session[:current_info]['child_number'] ||= 0
    session[:current_info]['household_size'] = 1 + session[:current_info]['family_number'] + session[:current_info]['child_number']
  end    
end

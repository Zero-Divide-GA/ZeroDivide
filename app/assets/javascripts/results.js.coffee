show_toggle = (elt) ->
	if $(elt).css('visibility') == 'hidden'
		$(elt).css('visibility', 'visible')
	else if $(elt).css('visibility') == 'visible'
		$(elt).css('visibility', 'hidden')
	null

$ ->
	$('.box').click( (eventObject) -> 
		show_toggle($(this).parent().find('.popup')[0])

		if $(this).hasClass 'selected'
			$(this).removeClass 'selected'
			$(this).addClass 'unselected'
		else if $(this).hasClass 'unselected'
			$(this).removeClass 'unselected'
			$(this).addClass 'selected'			
	)

	$(".action-box").click( (eventObject) ->
		curr_info_hash = $("div#current_info").data('value')
		plan_data = {'plan': {state: curr_info_hash['state'], county: curr_info_hash['county']}}
		plan_data['plan']['plan_id']=$(this).parent().parent().find('.plan-name').data('plan-id')
		$.ajax({ 
			url: '/api/v1/users/add_plan.json',
			type: 'post',
			dataType: 'json',
			data: plan_data,
			success:  null
			})
		null
	)

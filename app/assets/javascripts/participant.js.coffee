# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
Participant =
  calculate_category: ->
    yob=$('#participant_category_id').data('restrict-yob')
    gender=$('#participant_category_id').data('restrict-gender')
    callback = (response) -> Participant.update_category response
    $.get $('#participant_category_id').data('source'), {yob, gender}, callback, 'json'

  update_category: (response)->
    #console.log(response)
    $('#participant_category_id').empty()
    first=true
    for item in response
      if first
        $('#participant_category_id').append($("<option></option>").attr("value", item["id"]).attr("selected","selected").text(item["title"]))
      else
        $('#participant_category_id').append($("<option></option>").attr("value", item["id"]).text(item["title"]))

Category =
  prepare_field: (data_in_json)->
    console.log(data_in_json)

    $("#participant_person_county_id").select2
      createSearchChoice: (term,data) ->
        if ($(data).filter( ->
          this.text.localeCompare(term) is 0
        ).length is 0)
          id: term,
          text: term
      data: data_in_json
    $("#participant_person_county_id").on("change", Category.load_county_people)


  prepare_county_people: (html_data)->
    $("#county_people").replaceWith(html_data)

  load_county_people: ->
    console.log("load_county_people ")
    county_id=$("#participant_person_county_id").val()
    race_id=$("#participant_person_county_id").data("race-id")
    console.log(race_id+"/"+county_id)
    $.get '/counties/'+county_id+'/people.html', {race_id:race_id}, Category.prepare_county_people, 'html'

  load_county_select: ->
    console.log("load_county_select")
    $.get '/counties.json', {}, Category.prepare_field, 'json'

ready = ->
  console.log("Ready")
  Category.load_county_select()
  Category.load_county_people()
  Participant.calculate_category()

jQuery ->
  $('.restrict_yob').change ->
    $('#participant_category_id').data('restrict-yob',$(this).val())
    Participant.calculate_category()
    #console.log($('#participant_category_id').data('restrict-yob'))

  $('.restrict_gender').change ->
    $('#participant_category_id').data('restrict-gender',$(this).val())
    Participant.calculate_category()
    #console.log($('#participant_category_id').data('restrict-gender'))

  $(document).ready(ready)

  $(document).on('page:load', ready)

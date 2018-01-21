# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
Participant =
  init: ->
    if $('#participant_category_id').length
      console.log("Participant hook found")
      Participant.calculate_category()
      $('.restrict_yob').change ->
        $('#participant_category_id').data('restrict-yob',$(this).val())
        Participant.calculate_category()

      $('.restrict_gender').change ->
        $('#participant_category_id').data('restrict-gender',$(this).val())
        Participant.calculate_category()

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

County =
  init: ->
    if $("#participant_person_county_id").length
      console.log("County selector found")
      County.load_county_select()


    if $("#county_people").length
      console.log("County people div found")
      County.load_county_people()

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
    $("#participant_person_county_id").on("change", County.load_county_people)

    $("#participant_person_first_name").on("input", County.load_county_people)
    $("#participant_person_last_name").on("input", County.load_county_people)
    $("#participant_starting_no").on("input", County.load_county_people)

  load_county_select: ->
    console.log("load_county_select")
    $.get '/counties.json', {}, County.prepare_field, 'json'

  prepare_county_people: (html_data)->
    $("#county_people").replaceWith(html_data)

  load_county_people: ->
    console.log("load_county_people")
    county_id=$("#participant_person_county_id").val()
    race_id=$("#participant_person_county_id").data("race-id")
    if county_id && race_id
      participant_params={}
      ["person_first_name","person_last_name","starting_no"].forEach (k) ->
        v=encodeURIComponent($("#participant_"+k).val())
        if v
          participant_params[k]=v
      if $.isEmptyObject(participant_params)
        $.get '/counties/'+county_id+'/people.html', {race_id:race_id}, County.prepare_county_people, 'html'
      else
        $.get '/counties/'+county_id+'/people.html?'+$.param(participant_params), {race_id:race_id}, County.prepare_county_people, 'html'

ready = ->
  console.log("Ready")
  County.init()
  Participant.init()

$(document).ready(ready)

$(document).on('page:load', ready)

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

prepare_field = (data_in_json)->
  console.log(data_in_json)

  $("#participant_person_county_id").select2
    createSearchChoice: (term,data) ->
      if ($(data).filter( ->
        this.text.localeCompare(term) is 0
      ).length is 0)
        id: term,
        text: term
    data: data_in_json

ready = ->
    $.get '/counties.json', {}, prepare_field, 'json'
$(document).ready(ready)
$(document).on('page:load', ready)

jQuery ->
  $('.restrict_yob').change ->
    $('#participant_category_id').data('restrict-yob',$(this).val())
    Participant.calculate_category()
    #console.log($('#participant_category_id').data('restrict-yob'))

  $('.restrict_gender').change ->
    $('#participant_category_id').data('restrict-gender',$(this).val())
    Participant.calculate_category()
    #console.log($('#participant_category_id').data('restrict-gender'))

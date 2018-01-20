Category =
  init: ->
    if $('#category_results').length
      console.log("Result div found")
      Category.load_category_results()

  prepare_category_results: (html_data)->
    $("#category_results").replaceWith(html_data)

  load_category_results: ->
    console.log("load_category_results")
    category_id=$('#category_results').data("category-id")
    race_id=$("#category_results").data("race-id")
    previous_id=$("#category_results").data("previous-id")
    if category_id && race_id
      console.log(race_id+"/"+category_id+"/"+previous_id)
      $.get '/races/'+race_id+'/categories/'+category_id+'/results.html?previous_id='+previous_id, {}, Category.prepare_category_results, 'html'

ready = ->
  console.log("Ready")
  Category.init()

$(document).ready(ready)

$(document).on('page:load', ready)

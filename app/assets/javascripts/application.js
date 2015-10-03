// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require bootstrap-waitingfor
//= require_tree .
//

function addRow(data) {
   return $('<tr>').append(
     $('<td>').append($('<span>').text(data.host)),
     $('<td>').append($('<span>').text(data.item)),
     $('<td>').append($('<span>').text(data.clock))
   )
}

$(document).ready(function(){
  $('#search_form').on('ajax:success',function(e, data, status, xhr){
    $("#result_table").find('tbody').html(
      addRow(data)
    );
    $('#more_button').html($('<button>').addClass('btn btn-success btn-lg').attr('id', data.id).text("More"))
  }).on('ajax:error',function(e, xhr, status, error){
    $('#result_table').text('Failed.');
  });
  $('#more_button').on('click', 'button', function(){
    $.ajax({
      type: 'GET',
      url: 'next',
      data: {
        id: this.id
      },
      dataType: 'json',
      success: function(data){
        $('#result_table').find('tbody').append(
          addRow(data)
        );
        $('#more_button button').attr('id',data.id);
      },
      error: function(){
          alert('error')
      }
    });
  });
});

$(document).ajaxSend(function(event, request, settings) {
//  $('#loading-indicator').show();
//  $(".cover-container").find(":input").attr('disabled', true)
  waitingDialog.show('Waiting please', {dialogSize: 'sm', progressType: 'warning'});
});

$(document).ajaxComplete(function(event, request, settings) {
  //$('#loading-indicator').hide();
  //$(".cover-container").find(":input").attr('disabled', false)
  waitingDialog.hide();
});

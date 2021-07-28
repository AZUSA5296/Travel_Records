// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require jquery3
//= require popper
//= require bootstrap-sprockets
// require turbolinks
//= require jquery
//= require moment
//= require fullcalendar

//= require rails-ujs
//= require activestorage
//= require_tree .

$('input').on('change', function () {
    var image = $(this).prop('images')[0];
    $('p').text(image.name);
});

//投稿画像即時プレビュー
$(function(){
    $('#post_image').on('change', function (e) {
    var reader = new FileReader();
    reader.onload = function (e) {
        $(".image").attr('src', e.target.result);
    }
    reader.readAsDataURL(e.target.files[0]);
});
});

//フラッシュメッセージ
$(function(){
  setTimeout("$('#notice, #alert').fadeOut('slow')", 1000);
  });
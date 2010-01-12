$(document).ready(function(){
  $('form[data-remote=true]').ajaxForm({ dataType : 'script', clearForm: true });
});
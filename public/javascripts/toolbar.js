$(document).ready(function() {
  var editor = window.LiveDraft.Editors["draft"];

  $(".save-draft").click(function() {
    $.ajax({
      url: window.location,
      type: "POST",
      dataType: "json",
      data: { content: editor.getValue() },
      success: function(data) {
        window.location = data.redirect;
      },
      error: function() {
        alert("Oh no, an error!");
      }
    });
  });

  $(".clear-draft").click(function() {
    editor.setValue("");
  });
});

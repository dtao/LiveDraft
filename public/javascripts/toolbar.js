// TODO: Refactor this file.

$(document).ready(function() {
  var editor  = LiveDraft.Editor;
  var $format = $("select[name='format']");

  $(".save-draft").click(function() {
    $.ajax({
      url: window.location,
      type: "POST",
      dataType: "json",
      data: {
        content: editor.getValue(),
        format: $format.val()
      },
      success: function(data) {
        window.location = data.redirect;
      },
      error: function() {
        alert("Oh no, an error!");
      }
    });
  });

  $(".publish-draft").click(function() {
    $.ajax({
      url: "/publish/" + LiveDraft.DraftId,
      type: "POST",
      dataType: "json",
      data: {
        content: editor.getValue(),
        format: $format.val()
      },
      success: function(data) {
        window.location = data.redirect;
      },
      error: function() {
        alert("Oh no, an error!");
      }
    });
  });

  $(".unpublish-draft").click(function() {
    $.ajax({
      url: "/unpublish/" + LiveDraft.DraftId,
      type: "POST",
      dataType: "json",
      data: {
        content: editor.getValue(),
        format: $format.val()
      },
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

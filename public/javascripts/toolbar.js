// TODO: Refactor this file.

$(document).ready(function() {
  var editor = window.LiveDraft.Editor;

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

  $(".publish-draft").click(function() {
    $.ajax({
      url: "/publish/" + window.LiveDraft.DraftId,
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

  $(".unpublish-draft").click(function() {
    $.ajax({
      url: "/unpublish/" + window.LiveDraft.DraftId,
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

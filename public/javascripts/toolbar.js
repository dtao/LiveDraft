$(document).ready(function() {
  function sendData(url) {
    $.ajax({
      url: url,
      type: "POST",
      dataType: "json",
      data: {
        "content": LiveDraft.Editors["draft-content"].getValue(),
        "format": $("select[name='format']").val(),
        "style-content": LiveDraft.Editors["draft-style"].getValue(),
        "style-format": $("select[name='style_format']").val(),
        "script-content": LiveDraft.Editors["draft-script"].getValue(),
        "script-format": $("select[name='script_format']").val()
      },
      success: function(data) {
        window.location = data.redirect;
      },
      error: function() {
        alert("Oh no, an error!");
      }
    });
  }

  $(".save-draft").click(function() {
    sendData(window.location);
  });

  $(".publish-draft").click(function() {
    sendData("/publish/" + LiveDraft.DraftId);
  });

  $(".unpublish-draft").click(function() {
    sendData("/unpublish/" + LiveDraft.DraftId);
  });

  $(".clear-draft").click(function() {
    LiveDraft.Editor.setValue("");
  });
});

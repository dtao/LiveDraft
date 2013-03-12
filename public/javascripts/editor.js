$(document).ready(function() {
  var $editor  = $(".editor textarea");
  var $preview = $(".preview");

  function throttle(delay, callback) {
    var timeoutId;
    var wait = false;

    return function() {
      var self = this;
      var args = arguments;
      var exec = function() {
        if (wait) {
          timeoutId = setTimeout(exec, delay);
          wait = false;
        } else {
          callback.apply(self, args);
          timeoutId = null;
        }
      };

      if (timeoutId) {
        wait = true;
      } else {
        timeoutId = setTimeout(exec, delay);
      }
    };
  }

  function updatePreview(editor) {
    $preview.addClass("loading");

    $.ajax({
      url: "/preview",
      type: "POST",
      dataType: "html",
      data: { content: editor.getValue() },
      success: function(html) {
        $preview.html(html);
      },
      error: function() {
        alert("Gah, something went wrong!");
      },
      complete: function() {
        $preview.removeClass("loading");
      }
    });
  }

  window.LiveDraft.Editor = CodeMirror.fromTextArea($editor[0], {
    mode: "gfm",
    lineNumbers: true,
    lineWrapping: true
  });

  window.LiveDraft.Editor.on("change", throttle(1000, function(editor, change) {
    updatePreview(editor);
  }));
});

window.LiveDraft = {
  Editors: {}
};

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

$(document).ready(function() {
  var $preview = $(".preview");

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

  $(".editor textarea").each(function() {
    window.LiveDraft.Editors[this.id] = CodeMirror.fromTextArea(this, {
      mode: "gfm",
      lineNumbers: true,
      lineWrapping: true
    });
  });

  window.LiveDraft.Editors["draft"].on("change", throttle(1000, function(editor, change) {
    updatePreview(editor);
  }));
});

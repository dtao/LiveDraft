$(document).ready(function() {
  var CONTENT_MODES = {
    "haml":     "haml",
    "html":     "htmlmixed",
    "markdown": "gfm"
  };

  var STYLESHEET_MODES = {
    "css":  "css",
    "sass": "sass"
  };

  var $format   = $("select[name='format']");
  var $editors  = $(".editor textarea");
  var $preview  = $(".preview");
  var $switches = $(".switch");

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
    $preview.addClass("busy");

    $.ajax($.extend(getUpdatePreviewOptions(editor), {
      complete: function() {
        $preview.removeClass("busy");
      }
    }));
  }

  function getUpdatePreviewOptions(editor) {
    var options = {
      url: "/preview",
      type: "POST",
      dataType: "html",
      data: {
        content: LiveDraft.Editors["draft-content"].getValue(),
        stylesheet: LiveDraft.Editors["draft-stylesheet"].getValue(),
        format: $format.val()
      }
    };

    if (LiveDraft.DraftId) {
      options.url += "/" + LiveDraft.DraftId;

    } else {
      options.success = function(html) {
        $preview.html(html);
      };
      options.error = function() {
        alert("Gah, something went wrong!");
      };
    }

    return options;
  }

  $editors.each(function() {
    var $editor  = $(this).parent();
    var editorId = $editor.attr("id");
    LiveDraft.Editors[editorId] = CodeMirror.fromTextArea(this, {
      mode: $editor.attr("data-mode"),
      lineNumbers: true,
      lineWrapping: true,
      readOnly: LiveDraft.ReadOnly
    });
  });

  // TODO: Clean up this legacy hackery.
  LiveDraft.Editor = LiveDraft.Editors["draft-content"];

  LiveDraft.Editor.on("change", throttle(1000, updatePreview));

  $format.change(function() {
    LiveDraft.Editor.setOption("mode", CONTENT_MODES[this.value]);
  });

  $switches.click(function() {
    $switches.removeClass("selected");

    var $link  = $(this).addClass("selected");
    var toHide = $link.attr("data-hide");
    var toShow = $link.attr("data-reveal");
    var editor = LiveDraft.Editors[(toShow || "").replace(/^#/, "")];

    $(toHide).hide();
    $(toShow).show();

    if (editor) {
      editor.refresh();
    }
  });
});

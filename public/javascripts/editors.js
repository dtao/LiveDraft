$(document).ready(function() {
  var MODES = {
    "html":     "htmlmixed",
    "markdown": "gfm"
  };

  var $formats  = $("select.format");
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
        "content": LiveDraft.Editors["draft-content"].getValue(),
        "format": $("select[name='format']").val(),
        "style-content": LiveDraft.Editors["draft-style"].getValue(),
        "style-format": $("select[name='style_format']").val(),
        "script-content": LiveDraft.Editors["draft-script"].getValue(),
        "script-format": $("select[name='script_format']").val()
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
    var $wrapper = $(this).parent();
    var editorId = $wrapper.attr("id");
    var editor   = CodeMirror.fromTextArea(this, {
      mode: $wrapper.attr("data-mode"),
      lineNumbers: true,
      lineWrapping: true,
      readOnly: LiveDraft.ReadOnly
    });

    editor.on("change", throttle(1000, updatePreview));

    LiveDraft.Editors[editorId] = editor;
  });

  // TODO: Clean up this legacy hackery.
  LiveDraft.Editor = LiveDraft.Editors["draft-content"];

  $formats.change(function() {
    var editorId = $(this).closest(".editor").attr("id");
    LiveDraft.Editors[editorId].setOption("mode", MODES[this.value] || this.value);
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

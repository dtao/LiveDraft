window.LiveDraft = {
  Editors: {}
};

$(document).ready(function() {
  $(".editor textarea").each(function() {
    window.LiveDraft.Editors[this.id] = CodeMirror.fromTextArea(this, {
      mode: "gfm",
      lineNumbers: true,
      lineWrapping: true
    });
  });
});

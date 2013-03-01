$(document).ready(function() {
  $(".editor textarea").each(function() {
    CodeMirror.fromTextArea(this, {
      mode: "gfm",
      lineNumbers: true,
      lineWrapping: true
    });
  });
});

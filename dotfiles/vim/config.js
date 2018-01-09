const activate = (oni) => {
   // access the Oni plugin API here

   // for example, unbind the default `<c-p>` action:
   oni.input.unbind("<c-p>")

   // or bind a new action:
   oni.input.bind("<c-enter>", () => alert("Pressed control enter"));
};

module.exports = {
    activate,
    // change configuration values here:
    "oni.useDefaultConfig": false,
    "oni.loadInitVim": true,

    "editor.fontSize": "16px",
    "editor.fontFamily": "Source Code Pro",
    "editor.completions.enabled": true,

    // extra
    "experimental.commandline.mode": false,
    "autoClosingPairs.enabled": false,  // by vim

    // display
    "oni.hideMenu": true,
    "statusbar.enabled": false,
    "tabs.mode": "native",
    "tabs.height": "1.8em",
    "statusbar.fontSize": "1.0em",
    "oni.enhancedSyntaxHighlighting": false,
    "ui.colorscheme": "gruvbox",
    "ui.animations.enabled": true,

    // editor
    "editor.clipboard.enabled": false,  // by vim
    "editor.scrollBar.visible": true,
    "editor.scrollBar.cursorTick.visible": true,

    // language
    "language.python.languageServer.command": "pyls",
}

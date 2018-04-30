const activate = (oni) => {
    // access the Oni plugin API here

    // for example, unbind the default `<c-p>` action:
    oni.input.unbind("<c-p>");

    // or bind a new action:
    // oni.input.bind("<c-enter>", () => alert("Pressed control enter"));
    oni.input.bind("<f8>", "markdown.togglePreview");
};

module.exports = {
    activate,

    "achievements.enabled": false,

    "oni.useDefaultConfig": false,
    "oni.loadInitVim": true,
    "oni.hideMenu": true,

    // editor
    "editor.clipboard.enabled": false, // by vim
    "editor.scrollBar.visible": true,
    "editor.scrollBar.cursorTick.visible": true,
    "editor.fontSize": "14px",
    "editor.fontFamily": "Source Code Pro",
    "editor.completions.enabled": "oni",

    // extra
    "experimental.markdownPreview.enabled": true,
    "autoClosingPairs.enabled": false, // by vim
    "autoUpdate.enabled": false,
    "learning.enabled": false,

    // display
    "tabs.mode": "native", // disabled
    "tabs.height": "1.8em",
    "statusbar.enabled": false,
    "statusbar.fontSize": "1.0em",
    "ui.colorscheme": "gruvbox",
    "ui.animations.enabled": true,
    "sidebar.enabled": false,
    "commandline.mode": false,

    // language
    "language.python.languageServer.command": "pyls",
}

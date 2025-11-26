[`easy-theme-preview`](https://github.com/ayys/easy-theme-preview.el) is an Emacs Lisp package that provides a simple,
interactive buffer for browsing, and previewing Emacs themes
using a **tabulated-list** interface.

You can also install new themes, then press "g" to refresh the buffer.

![](https://raw.githubusercontent.com/ayys/easy-theme-preview.el/refs/heads/master/assets/demo.gif)

# Installation

You can install the package from [melpa](https://melpa.org/#/easy-theme-preview) as such:

```scheme
(use-package easy-theme-preview)

```

# Usage

Execute the command `M-x easy-theme-preview` to open the theme
selection buffer.


# Keybindings

The `easy-theme-preview-mode` buffer uses the following keybindings:

| Key      | Action     | Description                                          |
|----------|------------|------------------------------------------------------|
| `RET`    | `select`   | Toggle the selected theme (load/disable).            |
| `d`      | `describe` | Show the documentation for the theme or its package. |
| `f`      | `filter`   | Cycle filter: All -> Dark -> Light -> All.           |
| `g`      | `refresh`  | Refresh buffer                                       |
| `q`      | `quit`     | Close buffer                                         |
| `h`, `?` | `help`     | Show a quick help message in the echo area.          |


# License

GPL-3.0-or-later


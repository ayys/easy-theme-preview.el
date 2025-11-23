[\`easy-theme-preview\`](https://git.sr.ht/~ayys/theme-preview-mode.el) is an Emacs Lisp package that provides a simple,
interactive buffer for browsing, and previewing Emacs themes
using a **tabulated-list** interface.

You can also install new themes, then press "g" to refresh the buffer.


# Installation

This package is not currently available on MELPA, but you can manually
install it by placing \`easy-theme-preview.el\` in your Emacs load path
and adding the following to your configuration:

    (require 'easy-theme-preview)


# Usage

Execute the command \`M-x easy-theme-preview\` to open the theme
selection buffer.


# Keybindings

The \`easy-theme-preview-mode\` buffer uses the following keybindings:

<table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="org-left" />

<col  class="org-left" />

<col  class="org-left" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-left">Key</th>
<th scope="col" class="org-left">Action</th>
<th scope="col" class="org-left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td class="org-left"><code>RET</code></td>
<td class="org-left">`select`</td>
<td class="org-left">Toggle the selected theme (load/disable).</td>
</tr>

<tr>
<td class="org-left"><code>d</code></td>
<td class="org-left">`describe`</td>
<td class="org-left">Show the documentation for the theme or its package.</td>
</tr>

<tr>
<td class="org-left"><code>f</code></td>
<td class="org-left">`filter`</td>
<td class="org-left">Cycle filter: All -&gt; Dark -&gt; Light -&gt; All.</td>
</tr>

<tr>
<td class="org-left"><code>g</code></td>
<td class="org-left">`refresh`</td>
<td class="org-left">Refresh buffer</td>
</tr>

<tr>
<td class="org-left"><code>q</code></td>
<td class="org-left">`quit`</td>
<td class="org-left">Close buffer</td>
</tr>

<tr>
<td class="org-left"><code>h</code>, <code>?</code></td>
<td class="org-left">`help`</td>
<td class="org-left">Show a quick help message in the echo area.</td>
</tr>
</tbody>
</table>


# License

GPL-3.0-or-later


# Setting up firefox

I haven't worked out how to script firefox setup yet.

## Tree Style Tabs setup

Gets rid of firefox tabs, firefox's own sidebar, and adds tree-style-tab.

* Add [this plugin](https://addons.mozilla.org/en-GB/firefox/addon/tree-style-tab/)
* Go to about:config
    * `sidebar.revamp = false`
    * `toolkit.legacyUserProfileCustomizations.stylesheets = true`
    * `browser.gesture.swipe.left = false`
    * `browser.gesture.swipe.right = false`
* Go to Help -> More Troubleshooting Information
    * Click Profile Directory -> Open Directory
    * `mkdir chrome`
    * Make the following `chrome/userChrome.css`:
```
#TabsToolbar {
  visibility: collapse !important;
}
#sidebar-header {
  display: none;
}

```
## Other plugins

* [Vimium](https://addons.mozilla.org/en-GB/firefox/addon/vimium-ff/)
* [Ublock Origin](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/)
* [Bitwarden](https://addons.mozilla.org/en-US/firefox/addon/bitwarden-password-manager/)

## Menu bar

Left to right:
* Tree Style Tab
* Back/forward
* URL Bar
* Reload page button
* Flexible space
* Bitwarden
* Ublock origin
* Addons menu

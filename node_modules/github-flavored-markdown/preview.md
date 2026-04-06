---
title: Live Preview
layout: default
---

This page provides a live GFM preview, rendered client-side using javascript.
The majority of the credit goes to the wonderful [Showdown](http://attacklab.net/showdown/) script, which handles the meat of the processing.
GFM modifications for newlines, underscore-words, autolinking and GitHub SHA1/issue link syntaxes were added.

User input
----------

<script type="text/javascript">
  var GitHub = {}
  GitHub.nameWithOwner = "mojombo/god";
</script>

<textarea id="user_input"></textarea>

Live preview
------------

<div id="result"></div>

### HTML

<textarea id="html_result"></textarea>

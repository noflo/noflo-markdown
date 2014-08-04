test = require 'noflo-test'

test.component('markdown/ToMarkdown').
  discuss('When receiving simple HTML').
    send.data('in', "<p>I am using <strong>markdown</strong>.</p>\n").
    discuss('Generated Markdown should be sent out').
      receive.data('out', 'I am using **markdown**.').
  next().
  discuss('When receiving HTML with DIVs').
    send.data('in', "<div class='foo'><p>I am <span>using</span> <strong>markdown</strong>.</p></div>\n").
    discuss('Generated Markdown should be sent out with DIVs stripped').
      receive.data('out', 'I am using **markdown**.').
export module

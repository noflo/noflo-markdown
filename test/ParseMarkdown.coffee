test = require 'noflo-test'

test.component('markdown/ParseMarkdown').
  discuss('When receiving a Markdown string').
    send.data('in', 'I am using __markdown__.').
    discuss('Generated HTML should be sent out').
      receive.data('out', "<p>I am using <strong>markdown</strong>.</p>\n").
export module

/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const noflo = require('noflo');
const toMarkdown = require('html2commonmark');

exports.getComponent = function() {
  const c = new noflo.Component;
  c.description = 'Convert HTML to Markdown';

  c.inPorts.add('in', {
    datatype: 'string',
    description: 'HTML source'
  }
  );
  c.inPorts.add('tags', {
    datatype: 'boolean',
    description: 'Whether to allow HTML tags inside Markdown',
    default: true,
    control: true
  }
  );
  c.outPorts.add('out',
    {datatype: 'string'});

  return c.process(function(input, output) {
    let converter;
    if (!input.hasData('in')) { return; }
    if (input.attached('tags').length && !input.hasData('tags')) { return; }
    const data = input.getData('in');

    const tags = input.has('tags') ? input.getData('tags') : true;

    const converterOptions = {
      rawHtmlElements: ['iframe', 'article', 'video', 'table'],
      interpretUnknownHtml: false
    };

    if (noflo.isBrowser()) {
      converter = new toMarkdown.BrowserConverter(converterOptions);
    } else {
      converter = new toMarkdown.JSDomConverter(converterOptions);
    }
    const renderer = new toMarkdown.Renderer();
    const ast = converter.convert(data);
    const markdown = renderer.render(ast);

    return output.sendDone({
      out: markdown});
  });
};

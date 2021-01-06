const noflo = require('noflo');
const toMarkdown = require('html2commonmark');

exports.getComponent = () => {
  const c = new noflo.Component();
  c.description = 'Convert HTML to Markdown';

  c.inPorts.add('in', {
    datatype: 'string',
    description: 'HTML source',
  });
  c.outPorts.add('out', {
    datatype: 'string',
  });

  return c.process((input, output) => {
    if (!input.hasData('in')) { return; }
    const data = input.getData('in');

    const converterOptions = {
      rawHtmlElements: ['iframe', 'article', 'video', 'table'],
      interpretUnknownHtml: false,
    };

    let converter;
    if (noflo.isBrowser()) {
      converter = new toMarkdown.BrowserConverter(converterOptions);
    } else {
      converter = new toMarkdown.JSDomConverter(converterOptions);
    }
    const renderer = new toMarkdown.Renderer();
    const ast = converter.convert(data);
    const markdown = renderer.render(ast);

    output.sendDone({
      out: markdown,
    });
  });
};

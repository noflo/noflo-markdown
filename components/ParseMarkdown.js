import { Component } from "@noflo/noflo";
import { HtmlRenderer, Parser } from "commonmark";

/**
 * Converts a Markdown string to HTML with the CommonMark reference
 * parser.
 * @returns {import("@noflo/noflo").Component} The configured component
 */
export function getComponent() {
  const c = new Component({
    description: "Convert Markdown to HTML",
    icon: "file-text-o",
    inPorts: {
      in: {
        datatype: "string",
        description: "Markdown source",
        required: true,
      },
    },
    outPorts: {
      out: {
        datatype: "string",
        description: "HTML output",
      },
      error: {
        datatype: "object",
      },
    },
  });

  c.process((input, output) => {
    if (!input.hasData("in")) {
      return;
    }
    const data = input.getData("in");
    try {
      const reader = new Parser();
      const renderer = new HtmlRenderer();
      const ast = reader.parse(data);
      output.sendDone({ out: renderer.render(ast) });
    } catch (error) {
      output.error(error instanceof Error ? error : new Error(String(error)));
      output.done();
    }
  });

  return c;
}

import assert from "node:assert/strict";
import { describe, it } from "node:test";
import * as noflo from "@noflo/noflo";

import { getComponent as getParseMarkdown } from "../components/ParseMarkdown.js";
import { getComponent as getToMarkdown } from "../components/ToMarkdown.js";

/**
 * Wires a single-in single-out component and sends one value.
 * @param {import("@noflo/noflo").Component} c
 * @param {Record<string, any>} inputs
 * @returns {Promise<any>}
 */
const run = async (c, inputs) => {
  const outSocket = noflo.internalSocket.createSocket();
  c.outPorts.out.attach(outSocket);
  const received = new Promise((resolve, reject) => {
    const timer = setTimeout(() => {
      reject(new Error("Timed out waiting for IP"));
    }, 2000);
    outSocket.addEventListener("ip", (/** @type {CustomEvent} */ event) => {
      if (event.detail.type === "data") {
        clearTimeout(timer);
        resolve(event.detail.data);
      }
    });
  });
  for (const [port, value] of Object.entries(inputs)) {
    const socket = noflo.internalSocket.createSocket();
    c.inPorts[port].attach(socket);
    socket.post(new noflo.IP("data", value));
  }
  return received;
};

describe("ParseMarkdown component", () => {
  it("converts Markdown to HTML", async () => {
    const c = getParseMarkdown();
    try {
      const html = await run(c, { in: "I am using __markdown__." });
      assert.equal(html, "<p>I am using <strong>markdown</strong>.</p>\n");
    } finally {
      await c.shutdown();
    }
  });
  it("reports failures on the error port", async () => {
    const c = getParseMarkdown();
    const errorSocket = noflo.internalSocket.createSocket();
    c.outPorts.error.attach(errorSocket);
    try {
      const errored = new Promise((resolve, reject) => {
        const timer = setTimeout(() => reject(new Error("Timed out")), 2000);
        errorSocket.addEventListener("ip", (/** @type {CustomEvent} */ event) => {
          if (event.detail.type === "data") {
            clearTimeout(timer);
            resolve(event.detail.data);
          }
        });
      });
      // An undefined payload becomes null and makes the parser throw
      const inSocket = noflo.internalSocket.createSocket();
      c.inPorts.in.attach(inSocket);
      inSocket.post(new noflo.IP("data", /** @type {any} */ (null)));
      const error = await errored;
      assert.ok(error instanceof Error);
    } finally {
      await c.shutdown();
    }
  });
});

describe("ToMarkdown component", () => {
  it("converts HTML to Markdown", async () => {
    const c = getToMarkdown();
    try {
      const markdown = await run(c, { in: "<p>I am using <strong>markdown</strong>.</p>" });
      assert.equal(markdown, "I am using **markdown**.");
    } finally {
      await c.shutdown();
    }
  });
  it("keeps raw HTML for media elements", async () => {
    const c = getToMarkdown();
    try {
      const markdown = await run(c, {
        in: '<h1>Video</h1><video src="movie.mp4"></video>',
      });
      assert.ok(markdown.includes("<video"));
      assert.ok(markdown.startsWith("Video\n====="));
    } finally {
      await c.shutdown();
    }
  });
});

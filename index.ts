// handler.ts
var handler_default = {
  async hello() {
    console.log('Hello from Bun!');
    return new Response(JSON.stringify({hello: 'world'}));
  },
};
export { handler_default as default };

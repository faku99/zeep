/** @type {import("snowpack").SnowpackUserConfig } */

module.exports = {
  mount: {
    public: "/",
    src: "/dist",
  },
  plugins: [
    /* ... */
  ],
  packageOptions: {
    /* ... */
  },
  devOptions: {
    /* ... */
  },
  buildOptions: {
    /* ... */
  },
  routes: [
    {
      match: "routes",
      src: ".*",
      dest: "/index.html"
    }
  ]
};

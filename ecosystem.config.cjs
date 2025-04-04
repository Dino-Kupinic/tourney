module.exports = {
  apps: [
    {
      name: "tourney-viewer",
      port: "3001",
      cwd: "./apps/viewer",
      script: "./.output/server/index.mjs",
      exec_mode: "cluster",
      instances: "max",
      env: {
        NODE_ENV: "production",
      },
    },
    {
      name: "tourney-admin",
      port: "3000",
      cwd: "./apps/admin",
      script: "./.output/server/index.mjs",
      exec_mode: "cluster",
      instances: 2,
      env: {
        NODE_ENV: "production",
        NUXT_PUBLIC_CLIENT_URL: "http://localhost:3001",
      },
    },
  ],
}

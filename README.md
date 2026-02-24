![tourney](./.github/assets/banner.png)

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/github/v/release/HTL-Steyr/tourney?color=blue)](https://github.com/HTL-Steyr/tourney/releases)
[![Last Commit](https://img.shields.io/github/last-commit/HTL-Steyr/tourney)](https://github.com/HTL-Steyr/tourney/commits)

[![Instagram](https://img.shields.io/badge/Instagram-E1306C?logo=instagram&logoColor=white)](https://www.instagram.com/htlsteyr/)
[![Website](https://img.shields.io/website?url=https%3A%2F%2Fwww.htl-steyr.ac.at&up_message=htl-steyr.ac.at&logo=google-chrome&logoColor=white)](https://www.htl-steyr.ac.at/)

# tourney

Mono repository for the tourney project. This project is a web application for managing tournaments.

It includes an admin dashboard for managing tournaments, teams/players, live scores, and a client app for tournament
attendees.

## ⏳ Activity

![Alt](https://repobeats.axiom.co/api/embed/bd1b64dfb166474122230a0f147ea9f77e408ad1.svg "Repobeats analytics image")

## ♻️ Release Cycle

tourney follows the [Semantic Versioning](https://semver.org/) guidelines.

## ✨ Installation and Configuration

### Installation for Development

1. clone the repository:

```bash
git clone https://github.com/Dino-Kupinic/tourney.git
```

#### Quick Installation Script

2. Run the installation script and follow the instructions

```bash
./scripts/setup.sh
```

> [!NOTE]
> Windows users need WSL installed.

Requirements:

- Docker
- Bun

#### Manual Installation

2. install packages

```bash
bun i
```

> [!TIP]
> If you don't have bun installed, checkout https://bun.sh to install for your operating system.

### Backend

1. run supabase

```bash
bun run start:supabase
```

> [!TIP]
> If you don't have docker installed, checkout https://www.docker.com/.

2. head to http://127.0.0.1:54323

If it works, great!

### Frontends

#### Admin

1. define environment variables

Create a `.env` file and checkout the `.env.example`.
Copy the content into your `.env` and replace the following fields with your own.

| Field                    | Description                                            |
| ------------------------ | ------------------------------------------------------ |
| `SUPABASE_URL`           | URL to Supabase API                                    |
| `SUPABASE_KEY`           | Anon key                                               |
| `SUPABASE_SERVICE_KEY`   | Service Role Key                                       |
| `NUXT_PUBLIC_CLIENT_URL` | URL of the viewer app, default `http://localhost:3001` |

2. run dev server

```bash
bun run dev:admin
```

3. Head to http://localhost:3000/

If it works, great!

#### Viewer

1. define environment variables

Create a `.env` file and checkout the `.env.example`. Copy the content into your `.env` and replace the following fields

| Field          | Description         |
| -------------- | ------------------- |
| `SUPABASE_URL` | URL to Supabase API |
| `SUPABASE_KEY` | Anon key            |

2. run dev server

```bash
bun run dev:viewer
```

3. Head to http://localhost:3001/

If it works, great!

#### User creator script

1. define environment variables

Create a `.env` file and checkout the `.env.example`. Copy the content into your `.env` and replace the following fields

| Field             | Description                   |
| ----------------- | ----------------------------- |
| `SUPABASE_URL`    | URL to Supabase API           |
| `SUPABASE_KEY`    | Anon key                      |
| `USERS_TO_CREATE` | See comment in `.env.example` |

2. run the script

```bash
bun run create:users
```

If it works, great! You can now log in in the admin dashboard with the created users.

## 🚀 Deployment

1. build the app

```bash
bun run build
```

> [!CAUTION]
> The following section will be deprecated in the future!

2. start the app

```bash
bun run app:start
```

> [!TIP]
> Didn't work?
> Try installing pm2 globally with `npm install pm2 -g`.
> For npm you need to install Node.js.

3. monitor the app

```bash
bun run app:monitor
```

4. enjoy the app!

## 😄 Authors

### Creator

- [@Dino Kupinic](https://www.github.com/Dino-Kupinic)

### Core Maintainer

- [@Leon Arbeithuber](https://github.com/larbeith)

## 🛠️ Tech Stack

- Nuxt 3
- Supabase
- Docker
- pm2

## Contributing

Contributions are always welcome! Feel free to create an issue or submit a pull request.
Please follow coding standards and commit message conventions.

## 😊 License

[MIT](https://choosealicense.com/licenses/mit/)

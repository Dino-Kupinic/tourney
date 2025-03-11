![tourney](./.github/assets/banner.png)

# tourney

Mono repository for the tourney project. This project is a web application for managing tournaments.

It includes an admin dashboard for managing tournaments, teams/players, live scores, and a client app for tournament
attendees.

> [!CAUTION]
> tourney is still in development. You will find bugs and broken/unfinished features.

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

2. install packages

```bash
pnpm i
```

> [!TIP]
> If you don't have node.js installed, checkout https://nodejs.org to install for your operating system.
> We recommend using the LTS version, preferably v20 or higher.

> [!TIP]
> If you don't have pnpm installed, checkout https://pnpm.io/installation to install for your operating system.

### Backend

1. run supabase

```bash
pnpm run start:supabase
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
|--------------------------|--------------------------------------------------------|
| `SUPABASE_URL`           | URL to Supabase API                                    |
| `SUPABASE_KEY`           | Anon key                                               |
| `SUPABASE_SERVICE_KEY`   | Service Role Key                                       |
| `NUXT_PUBLIC_CLIENT_URL` | URL of the viewer app, default `http://localhost:3001` |

2. run dev server

```bash
pnpm run dev:admin
```

3. Head to http://localhost:3000/

If it works, great!

#### Viewer

1. define environment variables

Create a `.env` file and checkout the `.env.example`. Copy the content into your `.env` and replace the following fields

| Field          | Description         |
|----------------|---------------------|
| `SUPABASE_URL` | URL to Supabase API |
| `SUPABASE_KEY` | Anon key            |

2. run dev server

```bash
pnpm run dev:viewer
```

3. Head to http://localhost:3001/

If it works, great!

#### User creator script

1. define environment variables

Create a `.env` file and checkout the `.env.example`. Copy the content into your `.env` and replace the following fields

| Field             | Description                   |
|-------------------|-------------------------------|
| `SUPABASE_URL`    | URL to Supabase API           |
| `SUPABASE_KEY`    | Anon key                      |
| `USERS_TO_CREATE` | See comment in `.env.example` |

2. run the script

```bash
pnpm run create:users
```

If it works, great! You can now log in in the admin dashboard with the created users.

### Further Steps

#### Image Buckets

1. Create `images` and `misc` bucket like below:

> [!NOTE]
> This step might be automated in the future.

![img.png](.github/image_bucket.png)
![img.png](.github/misc_bucket.png)
*The `images` and `misc` bucket*

2. Create the following folders in the `images` bucket:

- `logos`
- `variants`
- `tournament`

3. Move the contents from `/resources/logos` to the `logos` folder in the bucket.
4. Move the contents from `/resources/variants` to the `variants` folder in the bucket.
5. Move the contents from `/resources/tournament` to the `tournament` folder in the bucket.
6. It should look like this:

![img.png](.github/image_bucket_logos.png)
*.svg logos in the logos folder*

![img.png](.github/image_bucket_variants.png)
*.svg logo variants grouped in the variants folder*

3. Add the `news.md` file to the `misc` bucket.

![img.png](.github/news_file.png)

![img.png](.github/misc_news.png)
*The `news.md` file in the `misc` bucket*

This file will be used to display news in the viewer app. It is written in markdown and edited in the dashboard.

4. configure RLS policies

Allow the public role to read from the `images` and `misc` bucket. In `Policies under storage.buckets` add the following policy:

![img.png](.github/buckets_policy_read.png)

Allow everyone to read the `images` bucket.

![img.png](.github/image_bucket_policy.png)

Allow authenticated users to do everything in the `misc` bucket.

![img.png](.github/misc_policy.png)

#### Cron Jobs

1. enable cron in supabase

![img.png](.github/cron_page.png)

2. create the cron job to update registration status after expiration:

![img.png](.github/cron_query.png)
*The cron job query, can be found in `/resources/update_registration_status.sql`*

#### Realtime

Enable realtime for the table `match` and `result`.
You can do this in the supabase dashboard by navigating to the table and enabling the realtime toggle.

## 🚀 Deployment

1. build the app

```bash
pnpm run build
```

2. start the app

```bash
pnpm run app:start
```

> [!TIP]
> Didn't work?
> Try installing pm2 globally with `npm install pm2 -g`.

3. monitor the app

```bash
pnpm run app:monitor
```

4. enjoy the app!

## 😄 Author

- [@Dino Kupinic](https://www.github.com/Dino-Kupinic)

## 🛠️ Tech Stack

- Nuxt 3
- Supabase (Postgres)
- Docker
- pm2

## Contributing

Contributions are always welcome! Feel free to create an issue or submit a pull request.
Please follow coding standards and commit message conventions.

## 😊 License

[MIT](https://choosealicense.com/licenses/mit/)

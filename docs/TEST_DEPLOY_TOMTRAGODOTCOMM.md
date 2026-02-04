# Test deploy — Heroku app `tomtragodotcomm`

The branch **`upgrade-ruby-rails-heroku`** is pushed to GitHub. Your Heroku app is **tomtragodotcomm** and connected to GitHub.

---

## Option A: Deploy from Heroku Dashboard (GitHub connected)

1. Open [Heroku Dashboard](https://dashboard.heroku.com/) and select app **tomtragodotcomm**.
2. Go to **Deploy** tab.
3. Under "Deploy from GitHub", confirm the repo is **Dylantrebl/tomtrago.com**.
4. Set **Branch** to **`upgrade-ruby-rails-heroku`** (instead of `main` or `development`).
5. Click **Deploy branch**.
6. After the build, open **https://tomtragodotcomm.herokuapp.com** and check the app and assets.
7. In **More → Run console** run: `rails db:migrate` (if you use DB and migrations).
8. Ensure **Config Vars** include (Heroku Redis sets `REDIS_URL` if you use the add-on):
   - `RAILS_ENV=production`
   - `RAILS_SERVE_STATIC_FILES=1`
   - `RAILS_LOG_TO_STDOUT=1`
   - `SECRET_KEY_BASE` (set to a secret, e.g. from `rails secret`).

---

## Option B: Deploy from your machine (Heroku CLI)

From your machine (where Heroku CLI is installed):

```bash
cd /Users/air/tomtrago.com
heroku git:remote -a tomtragodotcomm   # if not already added
./bin/heroku-deploy-upgrade tomtragodotcomm
```

That script sets stack, buildpacks, Redis (if missing), config vars, pushes **upgrade-ruby-rails-heroku** to Heroku’s **main**, runs migrations, and tails logs.

---

## After deploy

- **URL:** https://tomtragodotcomm.herokuapp.com  
- **Logs:** Dashboard → tomtragodotcomm → **More → View logs**, or `heroku logs --tail -a tomtragodotcomm`  
- If the app errors on boot, check logs for missing **SECRET_KEY_BASE** or **REDIS_URL** and set them in Config Vars.

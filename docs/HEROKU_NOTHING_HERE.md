# "There's nothing here, yet" on Heroku

That page means the **web dyno is not serving your app**—usually it’s **crashing on boot**. Do this:

---

## 1. Check logs (see why it’s crashing)

In a terminal:

```bash
heroku logs --tail -a tomtragodotcomm
```

Or: Heroku Dashboard → **tomtragodotcomm** → **More** → **View logs**.

Look for lines right after the dyno starts: `State changed from starting to crashed` or a **Ruby/Rails error** (e.g. `SECRET_KEY_BASE`, `DATABASE_URL`, or a stack trace). That message is the cause.

---

## 2. Required config vars

In Dashboard → **tomtragodotcomm** → **Settings** → **Config vars** (or **Reveal Config Vars**), ensure you have:

| Variable | Required? | Notes |
|----------|-----------|--------|
| **SECRET_KEY_BASE** | Yes | Rails needs this. Generate with: `rails secret` (locally with Ruby 3.4), then set in Config vars. |
| **DATABASE_URL** | Yes | Set automatically when you add **Heroku Postgres**. If missing, add the add-on. |
| **RAILS_ENV** | Recommended | Set to `production`. |
| **RAILS_SERVE_STATIC_FILES** | Recommended | Set to `1`. |
| **RAILS_LOG_TO_STDOUT** | Recommended | Set to `1`. |
| **REDIS_URL** | Optional | Set automatically if you add **Heroku Redis**. Only needed for ActionCable. |

Most common fix: set **SECRET_KEY_BASE** and add **Heroku Postgres** (so **DATABASE_URL** exists).  
**Full list of vars from the original repo:** see [HEROKU_CONFIG_VARS.md](HEROKU_CONFIG_VARS.md).

---

## 3. Add-ons

- **Resources** tab → ensure **Heroku Postgres** is added (so the app can boot and run migrations).
- Optionally add **Heroku Redis** if you use ActionCable (REDIS_URL).

---

## 4. Restart after fixing

After setting config vars or add-ons:

- **Resources** → find the **web** dyno → open the **⋮** menu → **Restart dyno**.
- Or run: `heroku restart -a tomtragodotcomm`

Then reload the app URL. If it still shows “There’s nothing here”, check **logs** again for the new error.

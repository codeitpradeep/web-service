# my_web_project

A Flutter web application for a Tamil Nadu matrimonial service.

## Run locally

```shell
flutter pub get
flutter run -d chrome
```

## Deploy to GitHub Pages

The workflow in `.github/workflows/deploy.yml` builds the Flutter web app and deploys it to GitHub Pages when you push to `main` or `master`. It also supports manual runs from the repository's **Actions** tab.

1. Push this project to a GitHub repository.
2. In the repository, open **Settings → Pages** and set the build and deployment source to **GitHub Actions**.
3. Push to `main` or `master`, or start **Deploy Flutter web app to GitHub Pages** from the **Actions** tab.
4. When the deployment workflow completes, open the URL shown in the `github-pages` deployment environment. Project sites use `https://<owner>.github.io/<repository>/`; user/organization sites use `https://<owner>.github.io/`.

The workflow sets Flutter's base href for either kind of Pages site and includes `.nojekyll` so Pages serves Flutter's generated files.

## Backend configuration

The web app connects directly to Supabase. Configure appropriate database policies and authentication redirect URLs for your deployed Pages URL. Never put passwords, service-role keys, or other private credentials in this public client app. Any credentials previously committed to a repository should be rotated; deleting them from a file does not remove them from Git history.

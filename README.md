# Kaan

Kaan is a hyper-personalized audio platform designed specifically for Indian commuters. This application combines a Flutter-based frontend for mobile/web and a Supabase-powered backend for authentication, database storage, and serverless edge functions.

## Project Structure
- **/lib**: Contains the Flutter frontend source code.
- **/supabase**: Contains Supabase edge functions, migrations, and database schema.
- **/.env.example**: Template for the required environment variables.

---

## Prerequisites
Before you begin, ensure you have the following installed:
1. [Flutter SDK](https://docs.flutter.dev/get-started/install) (> 3.8.0)
2. [Supabase CLI](https://supabase.com/docs/guides/cli)
3. [Docker Desktop](https://www.docker.com/) (Required to run Supabase locally)

---

## 🛠 Step 1: Get Your API Keys

### Supabase
1. Create a project at [supabase.com](https://supabase.com).
2. Navigate to **Project Settings** > **API**.
3. Under **Project API keys**, copy the `Project URL` and the `anon public` key.

### OpenAI
1. Create an account at [platform.openai.com](https://platform.openai.com).
2. Navigate to **API Keys** and create a new **Secret Key**.
3. Copy the key (you won't be able to see it again).

---

## 🛠 Step 2: Configure the App

The app reads secrets using Dart's `--dart-define` mechanism. You have two ways to provide these:

### Option A: Command Line (CLI)
Run the app using the following format:
```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key \
  --dart-define=OPENAI_API_KEY=your-openai-key
```

### Option B: VS Code (Launch Config)
Create/Update `.vscode/launch.json` in your project root:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Kaan (Debug)",
      "request": "launch",
      "type": "dart",
      "toolArgs": [
        "--dart-define", "SUPABASE_URL=https://your-project.supabase.co",
        "--dart-define", "SUPABASE_ANON_KEY=your-anon-key",
        "--dart-define", "OPENAI_API_KEY=your-openai-key"
      ]
    }
  ]
}
```

---

## 🛠 Step 3: Backend Setup (Supabase)

### 1. Initialize Local Supabase (Optional for Local Dev)
If you want to run the database locally:
```bash
supabase start
```

### 2. Set Production Secrets (For Edge Functions)
If you are deploying Edge Functions, you must set the OpenAI key in Supabase:
```bash
supabase secrets set OPENAI_API_KEY=your-openai-key
```

### 3. Deploy Database Schema
If your Supabase project is empty, run the schema initialization:
```bash
supabase db push
```
*Or copy-paste the contents of `supabase/schema.sql` into the Supabase SQL Editor.*

---

## 📱 Running the Frontend

1. **Fetch Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Generate Code**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Launch**:
   ```bash
   flutter run -d chrome
   ```
   *(Ensure you've added the `--dart-define` flags as shown above)*

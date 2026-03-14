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
4. A supported IDE (VS Code, Android Studio, etc.)

---

## 🛠 Backend Setup (Supabase)

### 1. Start the Local Supabase Stack
Make sure Docker is running on your machine, then navigate to your project root and start Supabase:
```bash
supabase start
```
*Note: This will download several Docker images on its first run and may take a few minutes.*

Once started, the CLI will output your local credentials. Note down your **API URL** and **anon key** to use in your `.env` file.

### 2. Stop Supabase
When you're done developing, you can stop the local stack securely:
```bash
supabase stop
```

---

## 📱 Frontend Setup (Flutter)

### 1. Configure Environment Variables
Copy the provided `.env.example` file to create your own configuration:
```bash
cp .env.example .env
```
Open the `.env` file and replace the placeholder values:
- `SUPABASE_URL`: Your local Supabase API URL (or production URL).
- `SUPABASE_ANON_KEY`: Your local Supabase anon key.
- `OPENAI_API_KEY`: Your OpenAI API key (if required).

### 2. Fetch Dependencies
Install all the necessary Dart/Flutter packages:
```bash
flutter pub get
```

### 3. Generate Code
This project uses `build_runner` for code generation (e.g. for Riverpod and json_serializable). Run it to generate the necessary files:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Run the Application
You're ready to go! Run the app on your connected device, emulator, or simulator:
```bash
flutter run
```
To explicitly run the web version:
```bash
flutter run -d chrome
```

# Payment Dashboard System

A full-stack real-time Payment Management Dashboard built with **Flutter (Web)** and **NestJS**. This system allows admins to simulate payments, view real-time transaction data, manage users, and analyze revenue trends.


# Live Demo

- 🔗 Frontend (Flutter Web): (https://payment-dashboard-system-2f282.web.app)
- 🔗 Backend (NestJS API): https://payment-dashboard-system.onrender.com

---

## Tech Stack

| Layer     | Technology           |
|-----------|----------------------|
| Frontend  | Flutter (Web)        |
| Backend   | NestJS (Node.js)     |
| Database  | PostgreSQL           |
| Auth      | JWT                  |
| Hosting   | Firebase (frontend), Render (backend) |
| Charts    | fl_chart             |

---

## Features

## Authentication
- JWT-based login for admin and viewer roles

## Dashboard
- Today's total revenue
- Failed transactions count
- Line chart for revenue trend (mock or real)

## Payments
- View paginated transactions
- Filter by status, date, and method
- Simulate new payments

## Users
- Admin can create new users (admin/viewer)
- View all registered users

## Export
- Export filtered transactions as CSV

## Project Structure

payment-dashboard-system/
├── backend/ # NestJS backend (API)
├── frontend/ # Flutter frontend (Web)

yaml
Copy
Edit

## Getting Started

## Backend (NestJS)

```bash
cd backend
npm install
npm run build
npm run start:prod
Environment Variables (.env)

ini
Copy
Edit
DATABASE_URL=postgresql://postgres:chandandatabase123@db.xwnbedptktivyzbccszf.supabase.co:5432/postgres
JWT_SECRET=superSecretKey



🌐 Frontend (Flutter Web)
bash
Copy
Edit
cd frontend
flutter pub get
flutter run -d chrome
To build for web:

bash
Copy
Edit
flutter build web
To deploy:

bash
Copy
Edit
firebase deploy
  Sample Credentials
You can log in with the default admin user (or create via POST /users):

json

{
  "username": "admin",
  "password": "admin123"
}

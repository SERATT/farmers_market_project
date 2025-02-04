## TL;DR
Simple Project which has web app, mobile app, and backend

## Project Structure
The directory src/main contains server-side code written in java + spring boot (RestAPI)
mobile is for mobile application implemented in flutter (designed for buyers and farmers)
web is for web application (designed as an admin dashboard for crud ops with users)

## Stack
Backend: Sprint Boot
Mobile: Flutter
Web: React

## Project Deployment
Deployed on cloud using Docker

## Testing
Manual :-(

## Run
```bash
mvn clean install
mvn spring-boot:run
cd farmers-market-web
npm run dev
```
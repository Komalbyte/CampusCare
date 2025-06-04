# CampusCare Admin Dashboard

React-based admin dashboard for managing complaints and viewing analytics.

## Tech Stack

- **React 18+** - UI library
- **Vite** - Build tool
- **Firebase** - Backend (Auth, Firestore, Storage)
- **React Router** - Navigation
- **Chart.js** - Analytics charts
- **TailwindCSS** - Styling (to be added)
- **React Query** - Data fetching (to be added)

## Getting Started

### Prerequisites

- Node.js 18+ installed
- Firebase project created
- Admin user created in Firebase

### Installation

```bash
# Install dependencies
npm install

# Install additional packages
npm install firebase react-router-dom recharts lucide-react
npm install -D tailwindcss postcss autoprefixer
```

### Configuration

1. Create `src/config/firebase.config.js` with your Firebase credentials:

```javascript
export const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "campuscare-sharda.firebaseapp.com",
  projectId: "campuscare-sharda",
  storageBucket: "campuscare-sharda.appspot.com",
  messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
  appId: "YOUR_APP_ID"
};
```

2. Update environment variables in `.env`:

```env
VITE_FIREBASE_API_KEY=your_api_key
VITE_FIREBASE_AUTH_DOMAIN=your_auth_domain
VITE_FIREBASE_PROJECT_ID=your_project_id
VITE_FIREBASE_STORAGE_BUCKET=your_storage_bucket
VITE_FIREBASE_MESSAGING_SENDER_ID=your_sender_id
VITE_FIREBASE_APP_ID=your_app_id
```

### Run Development Server

```bash
npm run dev
```

App will be available at `http://localhost:5173`

### Build for Production

```bash
npm run build
npm run preview  # Preview production build
```

## Project Structure

```
admin_dashboard/
├── src/
│   ├── components/         # Reusable UI components
│   │   ├── common/        # Buttons, inputs, cards
│   │   ├── layout/        # Layout components
│   │   └── dashboard/     # Dashboard-specific
│   ├── pages/             # Page components
│   │   ├── Login.jsx
│   │   ├── Dashboard.jsx
│   │   ├── Complaints.jsx
│   │   ├── ComplaintDetail.jsx
│   │   ├── Analytics.jsx
│   │   └── Users.jsx
│   ├── services/          # Firebase services
│   │   ├── auth.service.js
│   │   ├── complaints.service.js
│   │   └── analytics.service.js
│   ├── hooks/             # Custom React hooks
│   ├── utils/             # Utility functions
│   ├── contexts/          # React contexts
│   ├── config/            # Configuration files
│   └── App.jsx            # Main app component
├── public/
└── package.json
```

## Features

### Implemented
- ✅ Vite setup with React
- ✅ Dev server running

### To Implement
- [ ] Firebase initialization
- [ ] Admin authentication
- [ ] Dashboard with stats
- [ ] Complaints list & filtering
- [ ] Complaint detail view
- [ ] Status updates
- [ ] Department assignment
- [ ] Analytics charts
- [ ] User management
- [ ] Export to PDF
- [ ] Real-time updates
- [ ] Responsive design

## Admin Features

### Dashboard
- Overview statistics
- Recent complaints
- Priority breakdown
- Department performance

### Complaints Management
- View all complaints
- Filter by status, category, priority, date
- Search complaints
- View complaint details with images
- Update status
- Assign to departments
- Add resolution notes
- Chat with student

### Analytics
- Complaints over time (line chart)
- Category breakdown (pie chart)
- Status distribution
- Average resolution time
- Department performance
- Student satisfaction ratings

### User Management
- View all students
- View admin users
- User details
- Activity logs

## Development Guidelines

### Code Style
- Use functional components with hooks
- Follow React best practices
- Use Tailwind for styling
- Keep components small and focused
- Use TypeScript (optional, but recommended)

### State Management
- Use React Context for global state
- Use React Query for server state
- Keep local state minimal

### File Naming
- Components: PascalCase (e.g., `ComplaintCard.jsx`)
- Utils: camelCase (e.g., `formatDate.js`)
- Hooks: camelCase with "use" prefix (e.g., `useAuth.js`)

## Deployment

### Vercel (Recommended)
```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel
```

### Netlify
```bash
# Build
npm run build

# Deploy dist folder to Netlify
```

### Firebase Hosting
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize
firebase init hosting

# Deploy
firebase deploy --only hosting
```

## Environment Variables

Required environment variables:

- `VITE_FIREBASE_API_KEY` - Firebase API key
- `VITE_FIREBASE_AUTH_DOMAIN` - Firebase auth domain
- `VITE_FIREBASE_PROJECT_ID` - Firebase project ID
- `VITE_FIREBASE_STORAGE_BUCKET` - Firebase storage bucket
- `VITE_FIREBASE_MESSAGING_SENDER_ID` - Firebase messaging sender ID
- `VITE_FIREBASE_APP_ID` - Firebase app ID

## Security

- Admin emails must be whitelisted in Firestore `admin` collection
- All API calls check for admin role
- Firestore security rules enforce admin-only access
- No sensitive data in frontend code
- Use environment variables for configuration

## Testing

```bash
# Run tests (to be implemented)
npm test

# Run tests in watch mode
npm test -- --watch
```

## License

For educational purposes - Sharda University

import { useState } from 'react'
import './index.css'
import LoginPage from './pages/LoginPage'
import DashboardPage from './pages/DashboardPage'
import ComplaintsPage from './pages/ComplaintsPage'
import Sidebar from './components/Sidebar'

function App() {
  const [isLoggedIn, setIsLoggedIn] = useState(false)
  const [currentPage, setCurrentPage] = useState('dashboard')
  const [adminUser, setAdminUser] = useState(null)

  const handleLogin = (user) => {
    setAdminUser(user)
    setIsLoggedIn(true)
  }

  const handleLogout = () => {
    setAdminUser(null)
    setIsLoggedIn(false)
  }

  if (!isLoggedIn) {
    return <LoginPage onLogin={handleLogin} />
  }

  const renderPage = () => {
    switch (currentPage) {
      case 'dashboard':
        return <DashboardPage />
      case 'complaints':
        return <ComplaintsPage />
      default:
        return <DashboardPage />
    }
  }

  return (
    <div className="app-container">
      <Sidebar
        currentPage={currentPage}
        onNavigate={setCurrentPage}
        adminUser={adminUser}
        onLogout={handleLogout}
      />
      <main className="main-content">
        {renderPage()}
      </main>
    </div>
  )
}

export default App

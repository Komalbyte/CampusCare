import { useState } from 'react'
import PropTypes from 'prop-types'

function LoginPage({ onLogin }) {
    const [email, setEmail] = useState('')
    const [password, setPassword] = useState('')
    const [error, setError] = useState('')
    const [isLoading, setIsLoading] = useState(false)

    const handleSubmit = async (e) => {
        e.preventDefault()
        setError('')
        setIsLoading(true)

        // Simulate login - in production, verify against Firebase
        await new Promise(resolve => setTimeout(resolve, 1000))

        // Demo admin credentials
        if (email === 'admin@campuscare.com' && password === 'admin123') {
            onLogin({
                name: 'Admin User',
                email: email,
                role: 'admin'
            })
        } else if (email && password.length >= 6) {
            // For demo, accept any valid-looking credentials
            onLogin({
                name: email.split('@')[0],
                email: email,
                role: 'admin'
            })
        } else {
            setError('Invalid credentials. Try admin@campuscare.com / admin123')
            setIsLoading(false)
        }
    }

    return (
        <div className="login-container">
            <div className="login-card">
                <div className="login-header">
                    <div className="login-logo">🏫</div>
                    <h1>CampusCare Admin</h1>
                    <p>Sign in to manage complaints</p>
                </div>

                <form onSubmit={handleSubmit}>
                    {error && (
                        <div style={{
                            padding: '12px 16px',
                            background: '#fee2e2',
                            color: '#991b1b',
                            borderRadius: '10px',
                            marginBottom: '20px',
                            fontSize: '14px'
                        }}>
                            {error}
                        </div>
                    )}

                    <div className="form-group">
                        <label>Email Address</label>
                        <input
                            type="email"
                            value={email}
                            onChange={(e) => setEmail(e.target.value)}
                            placeholder="admin@campuscare.com"
                            required
                        />
                    </div>

                    <div className="form-group">
                        <label>Password</label>
                        <input
                            type="password"
                            value={password}
                            onChange={(e) => setPassword(e.target.value)}
                            placeholder="Enter your password"
                            required
                        />
                    </div>

                    <button
                        type="submit"
                        className="btn btn-primary"
                        style={{ width: '100%', justifyContent: 'center', padding: '14px' }}
                        disabled={isLoading}
                    >
                        {isLoading ? 'Signing in...' : 'Sign In'}
                    </button>
                </form>

                <div style={{
                    marginTop: '24px',
                    padding: '16px',
                    background: 'var(--bg-tertiary)',
                    borderRadius: '10px',
                    fontSize: '13px',
                    color: 'var(--text-secondary)'
                }}>
                    <strong>Demo Credentials:</strong><br />
                    Email: admin@campuscare.com<br />
                    Password: admin123
                </div>
            </div>
        </div>
    )
}

LoginPage.propTypes = {
    onLogin: PropTypes.func.isRequired
}

export default LoginPage

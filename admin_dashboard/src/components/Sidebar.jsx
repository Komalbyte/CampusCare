import PropTypes from 'prop-types'

function Sidebar({ currentPage, onNavigate, adminUser, onLogout }) {
    const navItems = [
        { id: 'dashboard', label: 'Dashboard', icon: '📊' },
        { id: 'complaints', label: 'Complaints', icon: '📋' },
    ]

    return (
        <aside className="sidebar">
            <div className="sidebar-logo">
                <div className="sidebar-logo-icon">🏫</div>
                <span className="sidebar-logo-text">CampusCare</span>
            </div>

            <nav className="sidebar-nav">
                {navItems.map((item) => (
                    <div
                        key={item.id}
                        className={`nav-item ${currentPage === item.id ? 'active' : ''}`}
                        onClick={() => onNavigate(item.id)}
                    >
                        <span className="nav-item-icon">{item.icon}</span>
                        <span>{item.label}</span>
                    </div>
                ))}
            </nav>

            <div style={{ borderTop: '1px solid rgba(255,255,255,0.1)', paddingTop: '16px', marginTop: 'auto' }}>
                <div style={{ padding: '12px 16px', display: 'flex', alignItems: 'center', gap: '12px' }}>
                    <div style={{
                        width: '36px',
                        height: '36px',
                        borderRadius: '50%',
                        background: 'var(--primary)',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        fontSize: '14px'
                    }}>
                        👤
                    </div>
                    <div style={{ flex: 1 }}>
                        <div style={{ fontWeight: '600', fontSize: '14px' }}>{adminUser?.name || 'Admin'}</div>
                        <div style={{ fontSize: '12px', color: 'var(--text-tertiary)' }}>Administrator</div>
                    </div>
                </div>
                <div
                    className="nav-item"
                    onClick={onLogout}
                    style={{ color: '#ef4444' }}
                >
                    <span className="nav-item-icon">🚪</span>
                    <span>Logout</span>
                </div>
            </div>
        </aside>
    )
}

Sidebar.propTypes = {
    currentPage: PropTypes.string.isRequired,
    onNavigate: PropTypes.func.isRequired,
    adminUser: PropTypes.object,
    onLogout: PropTypes.func.isRequired
}

export default Sidebar

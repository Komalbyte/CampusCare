import { useState, useEffect } from 'react'
import { mockComplaints } from '../data/mockData'
import { subscribeToComplaints } from '../services/firestore'

function DashboardPage() {
    const [complaints, setComplaints] = useState([])
    const [stats, setStats] = useState({
        total: 0,
        pending: 0,
        inProgress: 0,
        resolved: 0
    })
    const [useFirebase, setUseFirebase] = useState(true)
    const [isLoading, setIsLoading] = useState(true)

    useEffect(() => {
        // Try to subscribe to Firebase
        const unsubscribe = subscribeToComplaints((firebaseComplaints) => {
            if (firebaseComplaints.length > 0) {
                setComplaints(firebaseComplaints)
                setUseFirebase(true)
            } else {
                setComplaints(mockComplaints)
                setUseFirebase(false)
            }
            setIsLoading(false)
        })

        // Fallback timeout
        const timeout = setTimeout(() => {
            if (complaints.length === 0) {
                setComplaints(mockComplaints)
                setUseFirebase(false)
                setIsLoading(false)
            }
        }, 3000)

        return () => {
            unsubscribe()
            clearTimeout(timeout)
        }
    }, [])

    useEffect(() => {
        // Calculate stats whenever complaints change
        const total = complaints.length
        const pending = complaints.filter(c => c.status === 'submitted').length
        const inProgress = complaints.filter(c => ['in_progress', 'assigned'].includes(c.status)).length
        const resolved = complaints.filter(c => c.status === 'resolved').length

        setStats({ total, pending, inProgress, resolved })
    }, [complaints])

    const recentComplaints = [...complaints]
        .sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt))
        .slice(0, 5)

    const categoryStats = complaints.reduce((acc, c) => {
        acc[c.category] = (acc[c.category] || 0) + 1
        return acc
    }, {})

    if (isLoading) {
        return (
            <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '50vh' }}>
                <div style={{ textAlign: 'center' }}>
                    <div style={{ fontSize: '48px', marginBottom: '16px' }}>⏳</div>
                    <p>Loading dashboard...</p>
                </div>
            </div>
        )
    }

    return (
        <div>
            <div className="page-header">
                <h1>Dashboard</h1>
                <p>
                    Welcome back! Here&apos;s what&apos;s happening at CampusCare
                    {useFirebase ? (
                        <span style={{ marginLeft: '12px', padding: '4px 8px', background: '#d1fae5', color: '#065f46', borderRadius: '4px', fontSize: '12px' }}>
                            🔥 Live Data
                        </span>
                    ) : (
                        <span style={{ marginLeft: '12px', padding: '4px 8px', background: '#fef3c7', color: '#92400e', borderRadius: '4px', fontSize: '12px' }}>
                            📋 Demo Mode
                        </span>
                    )}
                </p>
            </div>

            {/* Stats Cards */}
            <div className="stats-grid">
                <div className="stat-card">
                    <div className="stat-icon primary">📋</div>
                    <div className="stat-content">
                        <h3>{stats.total}</h3>
                        <p>Total Complaints</p>
                    </div>
                </div>
                <div className="stat-card">
                    <div className="stat-icon warning">⏳</div>
                    <div className="stat-content">
                        <h3>{stats.pending}</h3>
                        <p>Pending Review</p>
                    </div>
                </div>
                <div className="stat-card">
                    <div className="stat-icon primary">🔄</div>
                    <div className="stat-content">
                        <h3>{stats.inProgress}</h3>
                        <p>In Progress</p>
                    </div>
                </div>
                <div className="stat-card">
                    <div className="stat-icon success">✅</div>
                    <div className="stat-content">
                        <h3>{stats.resolved}</h3>
                        <p>Resolved</p>
                    </div>
                </div>
            </div>

            {/* Main Content Grid */}
            <div style={{ display: 'grid', gridTemplateColumns: '2fr 1fr', gap: '24px' }}>
                {/* Recent Complaints */}
                <div className="card">
                    <div className="card-header">
                        <h3 className="card-title">Recent Complaints</h3>
                    </div>
                    {recentComplaints.length === 0 ? (
                        <div className="empty-state">
                            <p>No complaints yet</p>
                        </div>
                    ) : (
                        <div className="table-container">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Title</th>
                                        <th>Category</th>
                                        <th>Status</th>
                                        <th>Date</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {recentComplaints.map(complaint => (
                                        <tr key={complaint.id}>
                                            <td>
                                                <div style={{ fontWeight: '500' }}>{complaint.title}</div>
                                                <div style={{ fontSize: '12px', color: 'var(--text-secondary)' }}>
                                                    {complaint.location}
                                                </div>
                                            </td>
                                            <td>{complaint.category}</td>
                                            <td>
                                                <span className={`badge ${complaint.status}`}>
                                                    {complaint.status?.replace('_', ' ')}
                                                </span>
                                            </td>
                                            <td style={{ color: 'var(--text-secondary)', fontSize: '13px' }}>
                                                {complaint.createdAt ? new Date(complaint.createdAt).toLocaleDateString() : 'N/A'}
                                            </td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    )}
                </div>

                {/* Category Breakdown */}
                <div className="card">
                    <div className="card-header">
                        <h3 className="card-title">By Category</h3>
                    </div>
                    {Object.keys(categoryStats).length === 0 ? (
                        <div className="empty-state">
                            <p>No data</p>
                        </div>
                    ) : (
                        <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
                            {Object.entries(categoryStats).map(([category, count]) => (
                                <div key={category} style={{
                                    display: 'flex',
                                    justifyContent: 'space-between',
                                    alignItems: 'center',
                                    padding: '12px 16px',
                                    background: 'var(--bg-tertiary)',
                                    borderRadius: '10px'
                                }}>
                                    <span style={{ fontWeight: '500' }}>{category}</span>
                                    <span style={{
                                        background: 'var(--primary)',
                                        color: 'white',
                                        padding: '4px 12px',
                                        borderRadius: '20px',
                                        fontSize: '13px',
                                        fontWeight: '600'
                                    }}>{count}</span>
                                </div>
                            ))}
                        </div>
                    )}
                </div>
            </div>
        </div>
    )
}

export default DashboardPage

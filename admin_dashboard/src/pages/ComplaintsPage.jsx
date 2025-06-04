import { useState, useEffect } from 'react'
import { mockComplaints, categories, statuses } from '../data/mockData'
import { subscribeToComplaints, updateComplaintStatus as updateFirestoreStatus, addSampleComplaint } from '../services/firestore'

function ComplaintsPage() {
    const [complaints, setComplaints] = useState([])
    const [filteredComplaints, setFilteredComplaints] = useState([])
    const [selectedComplaint, setSelectedComplaint] = useState(null)
    const [showModal, setShowModal] = useState(false)
    const [useFirebase, setUseFirebase] = useState(true)
    const [isLoading, setIsLoading] = useState(true)

    // Filters
    const [statusFilter, setStatusFilter] = useState('')
    const [categoryFilter, setCategoryFilter] = useState('')
    const [searchQuery, setSearchQuery] = useState('')

    useEffect(() => {
        setIsLoading(true)

        // Try to subscribe to Firebase, fall back to mock data
        const unsubscribe = subscribeToComplaints((firebaseComplaints) => {
            if (firebaseComplaints.length > 0) {
                setComplaints(firebaseComplaints)
                setUseFirebase(true)
            } else {
                // If no data in Firebase, use mock data
                setComplaints(mockComplaints)
                setUseFirebase(false)
            }
            setIsLoading(false)
        })

        // Fallback to mock data after 3 seconds if no Firebase data
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
        let filtered = [...complaints]

        if (statusFilter) {
            filtered = filtered.filter(c => c.status === statusFilter)
        }
        if (categoryFilter) {
            filtered = filtered.filter(c => c.category === categoryFilter)
        }
        if (searchQuery) {
            const query = searchQuery.toLowerCase()
            filtered = filtered.filter(c =>
                c.title?.toLowerCase().includes(query) ||
                c.description?.toLowerCase().includes(query) ||
                c.userName?.toLowerCase().includes(query)
            )
        }

        setFilteredComplaints(filtered)
    }, [complaints, statusFilter, categoryFilter, searchQuery])

    const handleViewComplaint = (complaint) => {
        setSelectedComplaint(complaint)
        setShowModal(true)
    }

    const handleUpdateStatus = async (complaintId, newStatus, notes = '') => {
        if (useFirebase) {
            // Update in Firebase
            const success = await updateFirestoreStatus(complaintId, newStatus, notes)
            if (!success) {
                alert('Failed to update. Please try again.')
            }
        } else {
            // Update in local mock data
            setComplaints(prev => prev.map(c => {
                if (c.id === complaintId) {
                    return {
                        ...c,
                        status: newStatus,
                        updatedAt: new Date().toISOString(),
                        resolutionNotes: notes || c.resolutionNotes,
                        resolvedAt: newStatus === 'resolved' ? new Date().toISOString() : c.resolvedAt
                    }
                }
                return c
            }))
        }

        if (selectedComplaint?.id === complaintId) {
            setSelectedComplaint(prev => ({
                ...prev,
                status: newStatus,
                resolutionNotes: notes || prev.resolutionNotes
            }))
        }
    }

    const handleAddSample = async () => {
        const success = await addSampleComplaint()
        if (success) {
            alert('Sample complaint added! It will appear in the list.')
        } else {
            alert('Failed to add sample. Make sure Firestore is enabled.')
        }
    }

    const getPriorityClass = (priority) => {
        return `priority ${priority}`
    }

    if (isLoading) {
        return (
            <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '50vh' }}>
                <div style={{ textAlign: 'center' }}>
                    <div style={{ fontSize: '48px', marginBottom: '16px' }}>⏳</div>
                    <p>Loading complaints...</p>
                </div>
            </div>
        )
    }

    return (
        <div>
            <div className="page-header">
                <h1>Complaints Management</h1>
                <p>
                    View and manage all student complaints
                    {useFirebase ? (
                        <span style={{ marginLeft: '12px', padding: '4px 8px', background: '#d1fae5', color: '#065f46', borderRadius: '4px', fontSize: '12px' }}>
                            🔥 Live from Firebase
                        </span>
                    ) : (
                        <span style={{ marginLeft: '12px', padding: '4px 8px', background: '#fef3c7', color: '#92400e', borderRadius: '4px', fontSize: '12px' }}>
                            📋 Demo Mode
                        </span>
                    )}
                </p>
            </div>

            {/* Filters */}
            <div className="card" style={{ marginBottom: '24px' }}>
                <div className="filters">
                    <input
                        type="text"
                        placeholder="🔍 Search complaints..."
                        value={searchQuery}
                        onChange={(e) => setSearchQuery(e.target.value)}
                        style={{ minWidth: '250px' }}
                    />
                    <select value={statusFilter} onChange={(e) => setStatusFilter(e.target.value)}>
                        <option value="">All Statuses</option>
                        {statuses.map(s => (
                            <option key={s.value} value={s.value}>{s.label}</option>
                        ))}
                    </select>
                    <select value={categoryFilter} onChange={(e) => setCategoryFilter(e.target.value)}>
                        <option value="">All Categories</option>
                        {categories.map(c => (
                            <option key={c} value={c}>{c}</option>
                        ))}
                    </select>
                    <button
                        className="btn btn-secondary"
                        onClick={() => {
                            setStatusFilter('')
                            setCategoryFilter('')
                            setSearchQuery('')
                        }}
                    >
                        Clear
                    </button>
                    <button className="btn btn-primary" onClick={handleAddSample}>
                        + Seed Firebase
                    </button>
                </div>
            </div>

            {/* Complaints Table */}
            <div className="card">
                <div className="card-header">
                    <h3 className="card-title">
                        {filteredComplaints.length} Complaint{filteredComplaints.length !== 1 ? 's' : ''}
                    </h3>
                </div>

                {filteredComplaints.length === 0 ? (
                    <div className="empty-state">
                        <div className="empty-state-icon">📋</div>
                        <p>No complaints found</p>
                        {useFirebase && (
                            <button className="btn btn-primary" style={{ marginTop: '16px' }} onClick={handleAddSample}>
                                Add Sample Complaint
                            </button>
                        )}
                    </div>
                ) : (
                    <div className="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>Complaint</th>
                                    <th>Student</th>
                                    <th>Category</th>
                                    <th>Priority</th>
                                    <th>Status</th>
                                    <th>Date</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                {filteredComplaints.map(complaint => (
                                    <tr key={complaint.id}>
                                        <td>
                                            <div style={{ fontWeight: '500', marginBottom: '4px' }}>{complaint.title}</div>
                                            <div style={{ fontSize: '12px', color: 'var(--text-secondary)' }}>
                                                📍 {complaint.location}
                                            </div>
                                        </td>
                                        <td>
                                            <div style={{ fontWeight: '500' }}>{complaint.userName || 'Student'}</div>
                                            <div style={{ fontSize: '12px', color: 'var(--text-secondary)' }}>
                                                {complaint.userEmail || 'N/A'}
                                            </div>
                                        </td>
                                        <td>{complaint.category}</td>
                                        <td>
                                            <span className={getPriorityClass(complaint.priority || 'medium')}>
                                                {complaint.priority === 'high' && '🔴'}
                                                {complaint.priority === 'medium' && '🟡'}
                                                {complaint.priority === 'low' && '🟢'}
                                                {!complaint.priority && '🟡'}
                                                {' '}{complaint.priority || 'medium'}
                                            </span>
                                        </td>
                                        <td>
                                            <span className={`badge ${complaint.status}`}>
                                                {complaint.status?.replace('_', ' ') || 'submitted'}
                                            </span>
                                        </td>
                                        <td style={{ color: 'var(--text-secondary)', fontSize: '13px' }}>
                                            {complaint.createdAt ? new Date(complaint.createdAt).toLocaleDateString() : 'N/A'}
                                        </td>
                                        <td>
                                            <button
                                                className="btn btn-primary btn-sm"
                                                onClick={() => handleViewComplaint(complaint)}
                                            >
                                                View
                                            </button>
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>
                )}
            </div>

            {/* Complaint Detail Modal */}
            {showModal && selectedComplaint && (
                <ComplaintModal
                    complaint={selectedComplaint}
                    onClose={() => {
                        setShowModal(false)
                        setSelectedComplaint(null)
                    }}
                    onUpdateStatus={handleUpdateStatus}
                />
            )}
        </div>
    )
}

// Complaint Detail Modal Component
function ComplaintModal({ complaint, onClose, onUpdateStatus }) {
    const [newStatus, setNewStatus] = useState(complaint.status)
    const [resolutionNotes, setResolutionNotes] = useState(complaint.resolutionNotes || '')
    const [isSaving, setIsSaving] = useState(false)

    const handleSave = async () => {
        setIsSaving(true)
        await onUpdateStatus(complaint.id, newStatus, resolutionNotes)
        setIsSaving(false)
        onClose()
    }

    return (
        <div className="modal-overlay" onClick={onClose}>
            <div className="modal" onClick={(e) => e.stopPropagation()}>
                <div className="modal-header">
                    <h2>Complaint Details</h2>
                    <button className="modal-close" onClick={onClose}>×</button>
                </div>

                {/* Complaint Info */}
                <div style={{ marginBottom: '24px' }}>
                    <h3 style={{ marginBottom: '8px' }}>{complaint.title}</h3>
                    <div style={{ display: 'flex', gap: '12px', marginBottom: '16px' }}>
                        <span className={`badge ${complaint.status}`}>
                            {complaint.status?.replace('_', ' ')}
                        </span>
                        <span className={`priority ${complaint.priority || 'medium'}`}>
                            {complaint.priority === 'high' && '🔴'}
                            {complaint.priority === 'medium' && '🟡'}
                            {complaint.priority === 'low' && '🟢'}
                            {' '}{complaint.priority || 'medium'} priority
                        </span>
                    </div>
                </div>

                {/* Student Info */}
                <div style={{
                    padding: '16px',
                    background: 'var(--bg-tertiary)',
                    borderRadius: '10px',
                    marginBottom: '20px'
                }}>
                    <div style={{ fontWeight: '600', marginBottom: '4px' }}>{complaint.userName || 'Student'}</div>
                    <div style={{ fontSize: '13px', color: 'var(--text-secondary)' }}>{complaint.userEmail || 'N/A'}</div>
                </div>

                {/* Details */}
                <div className="form-group">
                    <label>Description</label>
                    <div style={{
                        padding: '12px 16px',
                        background: 'var(--bg-tertiary)',
                        borderRadius: '10px',
                        fontSize: '14px',
                        lineHeight: '1.6'
                    }}>
                        {complaint.description}
                    </div>
                </div>

                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px', marginBottom: '20px' }}>
                    <div>
                        <label style={{ display: 'block', marginBottom: '8px', fontWeight: '500' }}>Location</label>
                        <div style={{ color: 'var(--text-secondary)' }}>📍 {complaint.location}</div>
                    </div>
                    <div>
                        <label style={{ display: 'block', marginBottom: '8px', fontWeight: '500' }}>Category</label>
                        <div style={{ color: 'var(--text-secondary)' }}>{complaint.category}</div>
                    </div>
                </div>

                <hr style={{ border: 'none', borderTop: '1px solid var(--border)', margin: '24px 0' }} />

                {/* Update Status */}
                <h4 style={{ marginBottom: '16px' }}>Update Status</h4>

                <div className="form-group">
                    <label>Status</label>
                    <select value={newStatus} onChange={(e) => setNewStatus(e.target.value)}>
                        <option value="submitted">Submitted</option>
                        <option value="in_progress">In Progress</option>
                        <option value="assigned">Assigned</option>
                        <option value="resolved">Resolved</option>
                        <option value="rejected">Rejected</option>
                    </select>
                </div>

                <div className="form-group">
                    <label>Resolution Notes</label>
                    <textarea
                        value={resolutionNotes}
                        onChange={(e) => setResolutionNotes(e.target.value)}
                        placeholder="Add notes about the resolution..."
                        rows={3}
                    />
                </div>

                <div style={{ display: 'flex', gap: '12px', justifyContent: 'flex-end' }}>
                    <button className="btn btn-secondary" onClick={onClose}>
                        Cancel
                    </button>
                    <button
                        className="btn btn-primary"
                        onClick={handleSave}
                        disabled={isSaving}
                    >
                        {isSaving ? 'Saving...' : 'Save Changes'}
                    </button>
                </div>
            </div>
        </div>
    )
}

export default ComplaintsPage

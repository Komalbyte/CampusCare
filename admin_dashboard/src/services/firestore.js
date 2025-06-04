import {
    collection,
    getDocs,
    doc,
    updateDoc,
    query,
    orderBy,
    onSnapshot,
    addDoc,
    serverTimestamp
} from 'firebase/firestore';
import { db } from './firebase';
import { COLLECTIONS } from '../config/firebase.config';

// Get all complaints
export const getComplaints = async () => {
    try {
        const complaintsRef = collection(db, COLLECTIONS.COMPLAINTS);
        const q = query(complaintsRef, orderBy('createdAt', 'desc'));
        const snapshot = await getDocs(q);

        return snapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data(),
            createdAt: doc.data().createdAt?.toDate?.()?.toISOString() || new Date().toISOString(),
            updatedAt: doc.data().updatedAt?.toDate?.()?.toISOString() || new Date().toISOString(),
        }));
    } catch (error) {
        console.error('Error fetching complaints:', error);
        return [];
    }
};

// Subscribe to real-time complaints updates
export const subscribeToComplaints = (callback) => {
    const complaintsRef = collection(db, COLLECTIONS.COMPLAINTS);
    const q = query(complaintsRef, orderBy('createdAt', 'desc'));

    return onSnapshot(q, (snapshot) => {
        const complaints = snapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data(),
            createdAt: doc.data().createdAt?.toDate?.()?.toISOString() || new Date().toISOString(),
            updatedAt: doc.data().updatedAt?.toDate?.()?.toISOString() || new Date().toISOString(),
        }));
        callback(complaints);
    }, (error) => {
        console.error('Error subscribing to complaints:', error);
        callback([]);
    });
};

// Update complaint status
export const updateComplaintStatus = async (complaintId, status, resolutionNotes = '') => {
    try {
        const complaintRef = doc(db, COLLECTIONS.COMPLAINTS, complaintId);
        const updateData = {
            status,
            updatedAt: serverTimestamp(),
        };

        if (resolutionNotes) {
            updateData.resolutionNotes = resolutionNotes;
        }

        if (status === 'resolved') {
            updateData.resolvedAt = serverTimestamp();
        }

        await updateDoc(complaintRef, updateData);
        return true;
    } catch (error) {
        console.error('Error updating complaint:', error);
        return false;
    }
};

// Add a sample complaint (for testing)
export const addSampleComplaint = async () => {
    try {
        const complaintsRef = collection(db, COLLECTIONS.COMPLAINTS);
        await addDoc(complaintsRef, {
            userId: 'sample_user',
            userName: 'Test Student',
            userEmail: 'test@sharda.ac.in',
            category: 'Infrastructure',
            title: 'Sample Complaint from Admin',
            description: 'This is a test complaint added from the admin dashboard.',
            location: 'Main Building',
            priority: 'medium',
            status: 'submitted',
            createdAt: serverTimestamp(),
            updatedAt: serverTimestamp(),
            upvotes: 0
        });
        return true;
    } catch (error) {
        console.error('Error adding sample complaint:', error);
        return false;
    }
};

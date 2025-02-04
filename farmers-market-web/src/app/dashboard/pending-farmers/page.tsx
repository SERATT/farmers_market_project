'use client';

import { useState, useEffect } from 'react';
import DashboardLayout from '@/components/layout/DashboardLayout';
import { getPendingFarmers, approveFarmer, rejectFarmer } from '@/lib/api';

interface Farmer {
  userId: number;
  farmerId: number;
  email: string;
  phoneNumber: string;
}

export default function PendingFarmers() {
  const [farmers, setFarmers] = useState<Farmer[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    fetchPendingFarmers();
  }, []);

  const fetchPendingFarmers = async () => {
    try {
      setLoading(true);
      const data = await getPendingFarmers(0, 10); // Fetch first page with 10 items
      setFarmers(data.content);
    } catch (err) {
      setError('Failed to fetch pending farmers');
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return <DashboardLayout>Loading...</DashboardLayout>;
  }

  if (error) {
    return <DashboardLayout>Error: {error}</DashboardLayout>;
  }

  const handleApprove = async (userId: number) => {
    try {
      await approveFarmer(userId);
      setFarmers(farmers.filter(farmer => farmer.userId !== userId));
    } catch (err) {
      setError('Failed to approve farmer');
    }
  };

  const handleReject = async (userId: number) => {
    try {
      await rejectFarmer(userId);
      setFarmers(farmers.filter(farmer => farmer.userId !== userId));
    } catch (err) {
      setError('Failed to reject farmer');
    }
  };

  if (loading) {
    return <DashboardLayout>Loading...</DashboardLayout>;
  }

  if (error) {
    return <DashboardLayout>Error: {error}</DashboardLayout>;
  }

  return (
    <DashboardLayout>
      <div className="bg-white shadow overflow-hidden sm:rounded-lg">
        <div className="px-4 py-5 sm:px-6">
          <h3 className="text-lg leading-6 font-medium text-gray-900">
            Pending Farmer Applications
          </h3>
        </div>
        <div className="border-t border-gray-200">
          <ul className="divide-y divide-gray-200">
            {farmers.map((farmer) => (
              <li key={farmer.userId} className="px-4 py-4 sm:px-6">
                <div className="flex items-center justify-between">
                  <div className="flex-1">
                    <p className="text-sm font-medium text-indigo-600 truncate">
                      {farmer.email}
                    </p>
                    <p className="mt-1 text-sm text-gray-500">
                      Phone: {farmer.phoneNumber}
                    </p>
                  </div>
                  <div className="ml-4 flex-shrink-0">
                    <button
                      onClick={() => handleApprove(farmer.userId)}
                      className="mr-2 inline-flex items-center px-2.5 py-1.5 border border-transparent text-xs font-medium rounded text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500"
                    >
                      Approve
                    </button>
                    <button
                      onClick={() => handleReject(farmer.userId)}
                      className="inline-flex items-center px-2.5 py-1.5 border border-transparent text-xs font-medium rounded text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
                    >
                      Reject
                    </button>
                  </div>
                </div>
              </li>
            ))}
          </ul>
        </div>
      </div>
    </DashboardLayout>
  );
}

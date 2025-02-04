'use client';

import DashboardLayout from '@/components/layout/DashboardLayout';

export default function Dashboard() {
  return (
    <DashboardLayout>
      <div className="bg-white shadow overflow-hidden sm:rounded-lg">
        <div className="px-4 py-5 sm:px-6">
          <h3 className="text-lg leading-6 font-medium text-gray-900">
            Welcome to the Admin Dashboard
          </h3>
          <p className="mt-1 max-w-2xl text-sm text-gray-500">
            Here you can manage pending farmer applications and all users.
          </p>
        </div>
        <div className="border-t border-gray-200 px-4 py-5 sm:p-0">
          <dl className="sm:divide-y sm:divide-gray-200">
            <div className="py-4 sm:py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
              <dt className="text-sm font-medium text-gray-500">
                Pending Farmers
              </dt>
              <dd className="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                <a href="/dashboard/pending-farmers" className="text-indigo-600 hover:text-indigo-900">
                  View pending farmer applications
                </a>
              </dd>
            </div>
            <div className="py-4 sm:py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
              <dt className="text-sm font-medium text-gray-500">
                All Users
              </dt>
              <dd className="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                <a href="/dashboard/all-users" className="text-indigo-600 hover:text-indigo-900">
                  Manage all users
                </a>
              </dd>
            </div>
          </dl>
        </div>
      </div>
    </DashboardLayout>
  );
}

import axios from 'axios';

const API_BASE_URL = 'https://farmers-market-35xe.onrender.com/farmer-market-api';

const api = axios.create({
  baseURL: API_BASE_URL,
});

// Helper function to set cookie
const setCookie = (name: string, value: string, days: number = 7) => {
  const expires = new Date(Date.now() + days * 24 * 60 * 60 * 1000).toUTCString();
  document.cookie = `${name}=${value}; path=/; expires=${expires}`;
};

// Helper function to delete cookie
const deleteCookie = (name: string) => {
  document.cookie = `${name}=; path=/; expires=Thu, 01 Jan 1970 00:00:01 GMT`;
};

api.interceptors.request.use((config) => {
  const token = document.cookie
    .split('; ')
    .find(row => row.startsWith('token='))
    ?.split('=')[1];
    
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Update response interceptor to use cookie
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      deleteCookie('token'); // Use deleteCookie instead of localStorage
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

export const login = async (username: string, password: string) => {
  try {
    console.log(username + " " + password);
    const response = await api.post('/auth/signin', { 
      "username": username, 
      "password": password 
    });
    
    // Assuming the token is in response.data.token or response.data.accessToken
    const token = response.data.token || response.data.accessToken;
    if (token) {
      setCookie('token', token); // Use setCookie instead of localStorage
    } else {
      console.error('No token received in login response');
    }
    
    return response.data;
  } catch (error) {
    console.error('Login error:', error);
    throw error;
  }
};

export const logout = async () => {
  try {
    deleteCookie('token'); // Use deleteCookie instead of localStorage
    
    // Clear any other stored auth data if needed
    // sessionStorage.clear();
    
    return true;
  } catch (error) {
    console.error('Logout error:', error);
    throw error;
  }
};

// Rest of the API functions remain the same
export const getPendingFarmers = async (page: number, size: number) => {
  try {
    const response = await api.get(`/admin-board/pending-farmer-accounts?page=${page}&size=${size}`);
    return response.data;
  } catch (error) {
    console.error('Error fetching pending farmers:', error);
    throw error;
  }
};

export const approveFarmer = async (userId: number) => {
  const response = await api.put(`/admin-board/accept-user?userId=${userId}`);
  return response.data;
};

export const rejectFarmer = async (userId: number) => {
  try {
    // Log the current token for debugging
    const token = document.cookie
      .split('; ')
      .find(row => row.startsWith('token='))
      ?.split('=')[1];
    console.log('Current token:', token);

    const response = await api.delete(`/admin-board/reject-user?userId=${userId}`, {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    });
    console.log('Reject farmer response:', response);
    return response.data;
  } catch (error: any) {
    console.error('Reject farmer error:', {
      status: error.response?.status,
      message: error.response?.data,
      headers: error.config?.headers
    });
    throw error;
  }
};


export const getAllUsers = async (page: number, size: number) => {
  const response = await api.get(`/admin-board/user?page=${page}&size=${size}`);
  return response.data;
};

export default api;

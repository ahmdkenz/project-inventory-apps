import axios from 'axios';

const API_URL = 'http://localhost:8000/api';

axios.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

export const authService = {
  async login(credentials) {
    const response = await axios.post(`${API_URL}/auth/login`, credentials);
    return response.data;
  },

  async logout() {
    const response = await axios.post(`${API_URL}/auth/logout`);
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    return response.data;
  },

  async getCurrentUser() {
    const response = await axios.get(`${API_URL}/auth/me`);
    return response.data;
  },

  getStoredUser() {
    const userStr = localStorage.getItem('user');
    return userStr ? JSON.parse(userStr) : null;
  },

  isAuthenticated() {
    return !!localStorage.getItem('token');
  },

  getStoredToken() {
    return localStorage.getItem('token');
  },

  getUserRole() {
    const user = this.getStoredUser();
    return user ? user.role : null;
  },
};
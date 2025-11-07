import axios from 'axios';

const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:5000';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor for logging
api.interceptors.request.use(
  (config) => {
    console.log(`[API Request] ${config.method.toUpperCase()} ${config.url}`);
    return config;
  },
  (error) => {
    console.error('[API Request Error]', error);
    return Promise.reject(error);
  }
);

// Response interceptor for error handling
api.interceptors.response.use(
  (response) => {
    console.log(`[API Response] ${response.status} ${response.config.url}`);
    return response;
  },
  (error) => {
    console.error('[API Response Error]', error.response?.data || error.message);
    return Promise.reject(error);
  }
);

export const productService = {
  // Get all products
  getAllProducts: async () => {
    const response = await api.get('/api/products');
    return response.data;
  },

  // Get product by ID
  getProductById: async (id) => {
    const response = await api.get(`/api/products/${id}`);
    return response.data;
  },

  // Get products by category
  getProductsByCategory: async (category) => {
    const response = await api.get(`/api/products/category/${category}`);
    return response.data;
  },

  // Create new product
  createProduct: async (product) => {
    const response = await api.post('/api/products', product);
    return response.data;
  },

  // Update product
  updateProduct: async (id, product) => {
    const response = await api.put(`/api/products/${id}`, product);
    return response.data;
  },

  // Delete product
  deleteProduct: async (id) => {
    await api.delete(`/api/products/${id}`);
  },
};

export const healthService = {
  // Check API health
  checkHealth: async () => {
    const response = await api.get('/api/health');
    return response.data;
  },

  // Check API readiness
  checkReadiness: async () => {
    const response = await api.get('/api/health/ready');
    return response.data;
  },
};

export default api;

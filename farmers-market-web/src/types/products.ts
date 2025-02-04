// src/types/product.ts
export interface Product {
    id: number;
    name: string;
    description: string;
    price: number;
    quantity: number;
    category: string;
    farmerId: number;
  }
  
  export interface ProductResponse {
    content: Product[];
    totalPages: number;
    totalElements: number;
    size: number;
    number: number;
  }
  
  export interface CreateProductRequest {
    name: string;
    description: string;
    price: number;
    quantity: number;
    category: string;
  }
  
  export interface UpdateProductRequest {
    id: number;
    name?: string;
    description?: string;
    price?: number;
    quantity?: number;
    category?: string;
  }
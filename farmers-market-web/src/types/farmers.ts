// src/types/farmer.ts
export interface Farmer {
    userId: number;
    farmerId: number;
    email: string;
    phoneNumber: string;
    username?: string;
    farmSize?: number;
    farmCoordinates?: string;
    crops?: string[];
  }
  
  export interface FarmerResponse {
    content: Farmer[];
    totalPages: number;
    totalElements: number;
    size: number;
    number: number;
  }
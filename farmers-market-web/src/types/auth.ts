// src/types/auth.ts
export interface LoginRequest {
    username: string;
    password: string;
  }
  
  export interface LoginResponse {
    accessToken: string;
    tokenType: string;
    username: string;
    roles: string[];
  }
  
  export interface User {
    id: number;
    username: string;
    email: string;
    roles: string[];
  }
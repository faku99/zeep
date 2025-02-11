const BASE_URL = "http://localhost:3000/api/";

export interface ApiResponse<T> {
  data: T;
  error?: string;
  status: number;
}

export interface RequestConfig {
  headers?: Record<string, string>;
  params?: Record<string, string>;
}

export class ApiService {
  private static async request<T>(
    endpoint: string,
    method: string,
    config?: RequestConfig,
    body?: unknown,
  ): Promise<ApiResponse<T>> {
    try {
      const url = new URL(endpoint, BASE_URL);

      if (config?.params) {
        Object.entries(config.params).forEach(([key, value]) => {
          url.searchParams.append(key, value);
        });
      }

      const response = await fetch(url, {
        method,
        headers: {
          "Content-Type": "application/json",
          ...config?.headers,
        },
        body: body ? JSON.stringify(body) : undefined,
      });

      const data = await response.json();

      return {
        data,
        status: response.status,
      };
    } catch (error) {
      return {
        data: {} as T,
        error: error instanceof Error ? error.message : "Unknown error occurred",
        status: 500,
      };
    }
  }

  static async get<T>(endpoint: string, config?: RequestConfig): Promise<ApiResponse<T>> {
    return this.request<T>(endpoint, "GET", config);
  }

  static async post<T>(endpoint: string, body: unknown, config?: RequestConfig): Promise<ApiResponse<T>> {
    return this.request<T>(endpoint, "POST", config, body);
  }

  static async put<T>(endpoint: string, body: unknown, config?: RequestConfig): Promise<ApiResponse<T>> {
    return this.request<T>(endpoint, "PUT", config, body);
  }

  static async delete<T>(endpoint: string, config?: RequestConfig): Promise<ApiResponse<T>> {
    return this.request<T>(endpoint, "DELETE", config);
  }
}

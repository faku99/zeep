import { ApiResponse, ApiService } from "./api";

export interface Todo {
  id: string;
  title: string;
}

export class TodoService {
  private static readonly BASE_ENDPOINT = 'todo';

  static async getTodos(): Promise<ApiResponse<Todo[]>> {
    return ApiService.get<Todo[]>(this.BASE_ENDPOINT);
  }
}
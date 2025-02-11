import { useEffect, useState } from "react";

import { Todo, TodoService } from "./services/todo";

function App() {
  const [todos, setTodos] = useState<Todo[]>([]);

  useEffect(() => {
    async function getTodos() {
      const todos = await TodoService.getTodos();
      setTodos(todos.data);
    }
    getTodos();
  }, []);

  return (
    <div className="mx-auto w-1/2 bg-white">
      <div className="flex flex-col gap-2">
        {todos.map((todo) => (
          <span key={todo.id}>
            {todo.id} - {todo.title}
          </span>
        ))}
      </div>
    </div>
  );
}

export default App;

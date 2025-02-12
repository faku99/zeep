import { Button, Dialog, DialogPanel, Input, Textarea } from "@headlessui/react";
import { useState } from "react";
import { CreateTodo, TodoService } from "../services/todo";

function NavBar() {
  let [open, setOpen] = useState(false);
  let [title, setTitle] = useState("");
  let [content, setContent] = useState("");

  async function createNote() {
    console.log(`${title} - ${content}`);

    const note: CreateTodo = { title: title };

    await TodoService.create(note);
  }

  return (
    <div className="bg-black w-full text-white">
      <div className="w-1/2 mx-auto flex flex-row py-1 place-items-center justify-between">
        <div>
          <button className="font-bold">Zeep</button>
        </div>
        <div>
          <button onClick={() => setOpen(true)}>Create</button>
        </div>
        <Dialog open={open} onClose={() => {}} className="relative z-50">
          <div className="fixed inset-0 bg-black/30" aria-hidden="true" />
          <div className="fixed inset-0 flex w-screen items-center justify-center p-4">
            <DialogPanel className="w-full max-w-sm rounded bg-white p-4">
              <div className="flex flex-col gap-4 w-full mb-4">
                <Input
                  type="text"
                  placeholder="Title"
                  value={title}
                  className="w-full"
                  onInput={(e: React.ChangeEvent<HTMLInputElement>) => setTitle(e.target.value)}
                />
                <Textarea
                  placeholder="Take a note..."
                  value={content}
                  className="w-full"
                  onInput={(e: React.ChangeEvent<HTMLTextAreaElement>) => setContent(e.target.value)}
                />
              </div>
              <div className="flex flex-row gap-2 justify-end px-2">
                <Button
                  className="inline-flex items-center bg-gray-400 hover:bg-gray-300 text-white px-2 py-1 rounded"
                  onClick={() => setOpen(false)}
                >
                  Cancel
                </Button>
                <Button
                  className="inline-flex items-center bg-gray-400 hover:bg-gray-300 text-white px-2 py-1 rounded"
                  onClick={() => createNote()}
                >
                  Create
                </Button>
              </div>
            </DialogPanel>
          </div>
        </Dialog>
      </div>
    </div>
  );
}

export default NavBar;

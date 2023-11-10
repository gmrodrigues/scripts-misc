import re
from datetime import date
import tkinter as tk
import pyperclip

def process_chat_text(chat_text, user_name="Glauber"):
    chat_lines = chat_text.split("\n")
    user_pattern = r'^User$'
    bot_pattern = r'^ChatGPT$'
    version_info_pattern = r'^\d+ / \d+$'
    
    processed_lines = []
    user_interactions = 0

    for line in chat_lines:
        if re.match(user_pattern, line):
            user_interactions += 1
            line = "-- {} de x\n\n{}:".format(user_interactions, user_name)
        elif re.match(bot_pattern, line):
            line = "ChatGPT:"
        elif re.match(version_info_pattern, line):
            line = ''
        processed_lines.append(line)

    processed_text = "\n".join(processed_lines)
    processed_text = processed_text.replace("x", str(user_interactions)) # replacing 'x' with actual count

    processed_text = "GPT-4 {}\n\n{}".format(date.today().strftime("%d de %b de %Y"), processed_text)
    return processed_text

def get_clipboard():
    chat_text = root.clipboard_get()
    processed_text = process_chat_text(chat_text)
    output.delete('1.0', tk.END)
    output.insert(tk.END, processed_text)

def copy_to_clipboard():
    processed_text = output.get('1.0', tk.END)
    root.clipboard_clear()
    root.clipboard_append(processed_text)

root = tk.Tk()

input_frame = tk.Frame(root)
input_frame.pack(side=tk.TOP, padx=5, pady=5)

output_frame = tk.Frame(root)
output_frame.pack(side=tk.TOP, padx=5, pady=5)

copy_button = tk.Button(input_frame, text="Pegar da área de transferência", command=get_clipboard)
copy_button.pack(side=tk.LEFT)

paste_button = tk.Button(input_frame, text="Copiar para a área de transferência", command=copy_to_clipboard)
paste_button.pack(side=tk.LEFT)

output = tk.Text(output_frame, height=20, width=80)
output.pack()

root.mainloop()

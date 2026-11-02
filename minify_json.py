
import json
import sys
import os

def minify_json_file(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8-sig') as f:
            data = json.load(f)

        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, separators=(',', ':'), ensure_ascii=False)
        
        print(f"Successfully minified a file.")

    except Exception as e:
        print(f"Error processing a file: {e}")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        file_path = sys.argv[1]
        if os.path.exists(file_path):
            minify_json_file(file_path)
        else:
            print(f"File not found.")
    else:
        print("Please provide a file path.")
